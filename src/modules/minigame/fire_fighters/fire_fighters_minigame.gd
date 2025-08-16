class_name FireFightersMinigame
extends BaseMinigame

const BURN_TICK_INTERVAL = 15

@export var player_scene: PackedScene
@export var fire_scene: PackedScene
@export var water_scene: PackedScene
@export var extinguish_effect_scene: PackedScene
@export var explosion_effect_scene: PackedScene
@export var audio_effect_scene: PackedScene

@export var map_rect: Rect2i = Rect2i(0, 0, 50, 50)
@export var map_features: Array[FireFightersMinigameMapFeature]
@export var chunk_size: int = 5

@export var starting_fires: int = 25
@export var countdown_duration: float = 10.0

@export var max_water_per_fire: float = 0.1

@export var rng_seed: int = -1

var map_feature_lookup: Dictionary
var fires: Dictionary
var player: FireFightersMinigamePlayer
var saved_tiles: Array[Vector2i]
var countdown_bonus: int
var fires_bonus: int
var reduce_map_feature_thresholds: Dictionary

var _damage_effect_tween: Tween
var _fire_chunks: Dictionary

@onready var tile_map_terrain: TileMapLayer = $"TileMapLayer Terrain"
@onready var tile_map_objects: TileMapLayer = $"TileMapLayer Objects"
@onready var tile_map_water: TileMapLayer = $"TileMapLayer Water"
@onready var tile_map_oil: TileMapLayer = $"TileMapLayer Oil"

@onready var water_node: Node = $Water
@onready var fire_node: Node = $Fires
@onready var decal_node: Node = $Decals
@onready var item_node: Node = $Items
@onready var effects_node: Node = $Effects

@onready var item_spawner: FireFightersMinigameItemSpawner = $ItemSpawner
@onready var effects_player: FireFightersMinigameEffectsPlayer = $EffectsPlayer

@onready
var audio_container_oil: FireFightersMinigameAudioSequenceContainer = $"Audio/AudioContainer Oil"

@onready var damage_color_rect: ColorRect = $"Damage Overlay/ColorRect"


func _initialize():
	if rng_seed == -1:
		rng_seed = randi()

	for feature in map_features:
		map_feature_lookup[feature.atlas_coords] = feature
		if feature.spawn_noise:
			feature.spawn_noise.seed = rng_seed

	_init_chunks()
	_spawn_player()


func _start():
	player.init()

	FireFightersMinigameMapGenerator.generate_map(self)

	for i in starting_fires + fires_bonus:
		var tile := Vector2i(
			randi_range(map_rect.position.x, map_rect.position.x + map_rect.size.x),
			randi_range(map_rect.position.y, map_rect.position.y + map_rect.size.y)
		)
		_add_fire(tile, randf_range(0.2, 0.8))

	item_spawner.activate()


func _physics_process(_delta: float) -> void:
	if Engine.get_physics_frames() % BURN_TICK_INTERVAL == 0:
		_tick_fires()
	_tick_water()


func _init_chunks():
	for x in map_rect.size.x / chunk_size + 1:
		for y in map_rect.size.y / chunk_size + 1:
			_fire_chunks[Vector2i(x, y)] = 0.0


func _add_fire(tile: Vector2i, min_size: float = 0.0, max_size: float = 1.0):
	var fire: FireFightersMinigameFire = fire_scene.instantiate()
	fires[tile] = fire
	fire.position = tile_map_terrain.map_to_local(tile)
	fire_node.add_child(fire)
	fire.size = randf_range(min_size, max_size)
	fire.died.connect(_remove_fire.bind(fire))

	if tile in saved_tiles:
		var old_score: int = _score
		add_score(-1)
		# to make sure add_score() keeps supporting subtracting score
		assert(_score < old_score)
		saved_tiles.erase(tile)
		TextFloatSystem.floating_text(
			get_tile_position(tile),
			str("-1"),
			tile_map_terrain,
			TextFloatSystem.AnimationStyle.FLOAT,
			false,
			Color.WEB_PURPLE
		)


func _remove_fire(fire: FireFightersMinigameFire):
	var tile: Vector2i = fires.find_key(fire)
	if has_map_feature(tile):
		var feature: FireFightersMinigameMapFeature = get_map_feature(tile)
		if feature.can_burn():
			_vegetation_saved(tile)
	fires.erase(tile)
	fire.queue_free()


func add_water(pos: Vector2, vel: Vector2, impulse: Vector2, dir: Vector2):
	var water: FireFightersMinigameWater = water_scene.instantiate()
	water.position = pos
	water.velocity = vel + impulse
	water_node.add_child(water)
	water.look_at(water.position + dir)


func _tick_fires():
	var ctr := 0
	for tile: Vector2i in fires.keys():
		if ctr % 50 == 0:
			await get_tree().physics_frame
		if not fires.has(tile):
			continue

		var fire: FireFightersMinigameFire = fires[tile]
		var feature: FireFightersMinigameMapFeature = get_map_feature(tile)

		if (not feature or not feature.can_burn()) and not has_oil(tile):
			fire.size -= 0.02
		else:
			_fire_burn_tick(fire, tile, feature)
		ctr += 1

	_init_chunks()
	for tile: Vector2i in fires.keys():
		var fire: FireFightersMinigameFire = fires[tile]
		_set_fire_chunk(tile, clampf(fire.size, 0.0, 1.0))


func _fire_burn_tick(
	fire: FireFightersMinigameFire, tile: Vector2i, feature: FireFightersMinigameMapFeature
):
	# somehow not accurate?
	fire.total_burn += BURN_TICK_INTERVAL / 60.0

	if has_oil(tile):
		fire.size = 10.0
		_burn_vegetation(tile)
		if fire.total_burn > 3.5:
			_remove_oil(tile)
			fire.size = 1.0

	if feature and fire.total_burn > feature.burn_duration and feature.turns_into != null:
		replace_feature(tile, feature.turns_into)
		_burn_vegetation(tile)

	if feature:
		fire.size = min(1.5, fire.size + feature.flammability * 0.1)

	if RngUtils.chancef(fire.size - 1.0):
		_try_to_spread_fire(tile)


func _try_to_spread_fire(tile: Vector2i):
	var dir: Vector2i = Vector2.from_angle(randf() * 2 * PI).round()
	assert(abs(dir.x) == 1 or abs(dir.y) == 1)

	var neighbor_pos := Vector2i(tile + dir)
	if is_tile_burning(neighbor_pos):
		return

	if has_oil(neighbor_pos):
		_add_fire(neighbor_pos)
		return

	var neighbor_feature: FireFightersMinigameMapFeature = get_map_feature(tile + dir)
	if neighbor_feature:
		if RngUtils.chancef(neighbor_feature.flammability):
			if not RngUtils.chance100(tile_map_water.get_cell_source_id(tile)):
				_add_fire(neighbor_pos)


func _tick_water():
	for water: FireFightersMinigameWater in water_node.get_children():
		var tile: Vector2i = get_tile_at(water.position)
		var fire: FireFightersMinigameFire = get_fire_at(tile)

		if fire:
			var epsilon := 0.001
			var max_water: float = min(max_water_per_fire, water.density + epsilon)
			var final_water: float = min(max_water, fire.size + epsilon)
			fire.size -= final_water
			water.density -= final_water
		else:
			if has_map_feature(tile):
				_soak_tile(tile)

	for tile in tile_map_water.get_used_cells():
		if RngUtils.chance100(10):
			tile_map_water.set_cell(tile, tile_map_water.get_cell_source_id(tile) - 1)


func _soak_tile(tile: Vector2i):
	var water_level: int = tile_map_water.get_cell_source_id(tile)
	if not RngUtils.chance100(water_level):
		tile_map_water.set_cell(tile, water_level + 1, Vector2.ZERO)


func add_oil(tile: Vector2i, counter: int = -1):
	tile_map_oil.set_cell(tile, 0, Vector2.ZERO)
	if counter > -1:
		audio_container_oil.play(counter)


func _remove_oil(tile: Vector2i):
	tile_map_oil.erase_cell(tile)


func _spawn_player():
	player = player_scene.instantiate()
	player.position = tile_map_terrain.get_viewport_rect().size / 2
	add_child(player)
	player.extinguish_spot.connect(_on_extinguish_at)


func replace_feature(tile: Vector2i, new_feature: FireFightersMinigameMapFeature):
	tile_map_objects.set_cell(tile, 0, new_feature.atlas_coords)


func _burn_vegetation(tile: Vector2i):
	tile_map_terrain.set_cell(tile, -1)


func _on_extinguish_at(pos: Vector2):
	var tile: Vector2i = tile_map_terrain.local_to_map(pos)
	if fires.has(tile):
		var fire: FireFightersMinigameFire = fires[tile]
		fire.size -= 0.1


func _vegetation_saved(tile: Vector2i):
	add_score(1)
	saved_tiles.append(tile)

	var pos: Vector2 = get_tile_position(tile)
	var effect: Node2D = extinguish_effect_scene.instantiate()
	effect.position = pos
	effects_node.add_child(effect)
	TextFloatSystem.floating_text(
		pos, str("+1"), tile_map_terrain, TextFloatSystem.AnimationStyle.FLOAT, false, Color.YELLOW
	)


func oil_explosion(center_tile: Vector2i, radius: int, on_fire: bool):
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			var vec := Vector2i(x, y)
			if vec.length() > radius:
				continue

			var tile: Vector2i = center_tile + vec
			if is_tile_in_bounds(tile):
				add_oil(tile)
				if on_fire:
					_add_fire(tile, 0.1, 1.0)

	if on_fire:
		var explosion: Node2D = explosion_effect_scene.instantiate()
		explosion.position = get_tile_position(center_tile)
		effects_node.add_child(explosion)


func play_damage_effect():
	if _damage_effect_tween:
		_damage_effect_tween.kill()
	_damage_effect_tween = create_tween()
	damage_color_rect.modulate = Color.WHITE

	_damage_effect_tween.tween_property(damage_color_rect, "modulate", Color.TRANSPARENT, 0.3)
	_damage_effect_tween.tween_callback(damage_color_rect.hide)

	damage_color_rect.show()


func play_audio_effect(stream: AudioStream, pos: Vector2):
	var effect: AudioStreamPlayer2D = audio_effect_scene.instantiate()
	effect.position = pos
	effect.init(stream)
	effects_node.add_child(effect)


func _set_fire_chunk(tile: Vector2i, val: float):
	var coords: Vector2i = tile / chunk_size
	_fire_chunks[coords] = max(_fire_chunks[coords], val)


func stomp(tile: Vector2i) -> bool:
	if is_tile_burning(tile):
		_remove_fire(fires[tile])
		return true
	return false


func _get_countdown_duration() -> float:
	return countdown_duration + countdown_bonus


func get_tile_at(pos: Vector2) -> Vector2i:
	return tile_map_terrain.local_to_map(pos)


func get_tile_position(tile: Vector2i) -> Vector2:
	return tile_map_terrain.map_to_local(tile)


func get_map_feature(tile: Vector2i) -> FireFightersMinigameMapFeature:
	var atlas_coords: Vector2i = tile_map_objects.get_cell_atlas_coords(tile)
	return get_map_feature_from_atlas_coords(atlas_coords)


func has_map_feature(tile: Vector2i) -> bool:
	return tile in tile_map_objects.get_used_cells()


func get_map_feature_from_atlas_coords(coords: Vector2i) -> FireFightersMinigameMapFeature:
	if coords == Vector2i(-1, -1):
		return null
	assert(map_feature_lookup.has(coords))
	return map_feature_lookup[coords]


func get_fire_at(tile: Vector2i) -> FireFightersMinigameFire:
	if not is_tile_burning(tile):
		return null
	return fires[tile]


func is_tile_burning(tile: Vector2i) -> bool:
	return fires.has(tile)


func has_oil(tile: Vector2i) -> bool:
	return tile in tile_map_oil.get_used_cells()


func get_fire_density(tile: Vector2i) -> float:
	var result: float = 0.0
	for x in range(-1, 2):
		for y in range(-1, 2):
			var factor: float = 0.5
			var vec := Vector2i(x, y)
			if vec == Vector2i.ZERO:
				factor = 1.0
			result = max(result, _get_fire_chunk(tile + vec * chunk_size) * factor)

	return result


func _get_fire_chunk(tile: Vector2i) -> float:
	return _fire_chunks[_get_fire_chunk_coords(tile)]


func _get_fire_chunk_coords(tile: Vector2i) -> Vector2i:
	return tile / chunk_size


func get_random_tile() -> Vector2i:
	return Vector2i(
		randi_range(map_rect.position.x, map_rect.position.x + map_rect.size.x),
		randi_range(map_rect.position.y, map_rect.position.y + map_rect.size.y)
	)


func is_tile_in_bounds(tile: Vector2i) -> bool:
	return map_rect.has_point(tile)
