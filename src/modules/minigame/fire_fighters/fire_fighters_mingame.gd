class_name FireFightersMinigame
extends BaseMinigame

const BURN_TICK_INTERVAL = 10

@export var player_scene: PackedScene
@export var fire_scene: PackedScene
@export var water_scene: PackedScene

@export var map_rect: Rect2i = Rect2i(0, 0, 50, 50)
@export var map_features: Array[FireFightersMinigameMapFeature]

@export var max_water_per_fire: float = 0.1

var map_feature_lookup: Dictionary
var fires: Dictionary
var player: FireFighterMinigamePlayer

@onready var tile_map_terrain: TileMapLayer = $"TileMapLayer Terrain"
@onready var tile_map_objects: TileMapLayer = $"TileMapLayer Objects"
@onready var water_node: Node = $Water
@onready var fire_node: Node = $Fires


func _ready() -> void:
	init()
	run()


func init():
	for feature in map_features:
		map_feature_lookup[feature.atlas_coords] = feature

	FireFightersMinigameMapGenerator.generate_map(
		map_rect, tile_map_terrain, tile_map_objects, map_features
	)


func run():
	for i in 80:
		var tile := Vector2i(
			randi_range(map_rect.position.x, map_rect.position.x + map_rect.size.x),
			randi_range(map_rect.position.y, map_rect.position.y + map_rect.size.y)
		)
		add_fire(tile, randf_range(0.2, 0.8))

	spawn_player()


func _physics_process(_delta: float) -> void:
	if Engine.get_physics_frames() % BURN_TICK_INTERVAL == 0:
		tick_fires()
	tick_water()


func add_fire(tile: Vector2i, min_size: float = 0.0, max_size: float = 1.0):
	var fire: FireFightersMinigameFire = fire_scene.instantiate()
	fires[tile] = fire
	fire.position = tile_map_terrain.map_to_local(tile)
	fire.size = randf_range(min_size, max_size)
	fire_node.add_child(fire)
	fire.died.connect(remove_fire.bind(fire))


func remove_fire(fire: FireFightersMinigameFire):
	fires.erase(fires.find_key(fire))
	fire.queue_free()


func add_water(pos: Vector2, vel: Vector2):
	var water: FireFightersMinigameWater = water_scene.instantiate()
	water.position = pos
	water.velocity = vel
	water_node.add_child(water)


func tick_fires():
	for tile: Vector2i in fires.keys():
		var fire: FireFightersMinigameFire = fires[tile]
		var feature: FireFightersMinigameMapFeature = get_map_feature(tile)
		if not feature or not feature.can_burn():
			fire.size -= 0.01
		else:
			fire.total_burn += fire.size / (60.0 / BURN_TICK_INTERVAL)
			if fire.total_burn > feature.burn_duration:
				assert(feature.turns_into != null)
				replace_feature(tile, feature.turns_into)

			fire.size += feature.flammability * 0.1
			if RngUtils.chancef(fire.size - 1.0):
				try_to_spread_fire(tile)


func tick_water():
	for water: FireFightersMinigameWater in water_node.get_children():
		var tile: Vector2i = get_tile_at(water.position)
		var fire: FireFightersMinigameFire = get_fire_at(tile)
		if fire:
			var epsilon := 0.001
			var max_water: float = min(max_water_per_fire, water.density + epsilon)
			var final_water: float = min(max_water, fire.size + epsilon)
			fire.size -= final_water
			water.density -= final_water


func try_to_spread_fire(tile: Vector2i):
	var dir: Vector2i = Vector2.from_angle(randf() * 2 * PI).round()
	var neighbor_pos := Vector2i(tile + dir)
	assert(abs(dir.x) == 1 or abs(dir.y) == 1)
	var neighbor_feature: FireFightersMinigameMapFeature = get_map_feature(tile + dir)
	if neighbor_feature and not is_tile_burning(neighbor_pos):
		if RngUtils.chancef(neighbor_feature.flammability):
			add_fire(neighbor_pos)


func spawn_player():
	player = player_scene.instantiate()
	player.position = DisplayServer.window_get_size() / 2
	add_child(player)
	player.extinguish_spot.connect(on_extinguish_at)


func replace_feature(tile: Vector2i, new_feature: FireFightersMinigameMapFeature):
	tile_map_objects.set_cell(tile, 0, new_feature.atlas_coords)


func on_extinguish_at(pos: Vector2):
	var tile: Vector2i = tile_map_terrain.local_to_map(pos)
	if fires.has(tile):
		var fire: FireFightersMinigameFire = fires[tile]
		fire.size -= 0.1


func get_tile_at(pos: Vector2) -> Vector2i:
	return tile_map_terrain.local_to_map(pos)


func get_map_feature(tile: Vector2i) -> FireFightersMinigameMapFeature:
	var atlas_coords: Vector2i = tile_map_objects.get_cell_atlas_coords(tile)
	return get_map_feature_from_atlas_coords(atlas_coords)


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


func return_to_overworld() -> void:
	get_tree().change_scene_to_file("res://modules/settlement/breezekiln/breezekiln.tscn")
