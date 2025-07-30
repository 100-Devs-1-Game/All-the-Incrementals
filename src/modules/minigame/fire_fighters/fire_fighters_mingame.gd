class_name FireFightersMinigame
extends BaseMinigame

@export var player_scene: PackedScene
@export var fire_scene: PackedScene
@export var water_scene: PackedScene

@export var map_rect: Rect2i = Rect2i(0, 0, 50, 50)
@export var map_features: Array[FireFightersMapFeature]

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
	for i in 50:
		var tile := Vector2i(
			randi_range(map_rect.position.x, map_rect.position.x + map_rect.size.x),
			randi_range(map_rect.position.y, map_rect.position.y + map_rect.size.y)
		)
		add_fire(tile, randf_range(0.2, 0.8))

	spawn_player()


func _physics_process(_delta: float) -> void:
	if Engine.get_physics_frames() % 10 == 0:
		tick_fires()


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
		var feature: FireFightersMapFeature = get_map_feature(tile)
		if not feature:
			fire.size -= 0.01
		else:
			fire.size += feature.flammability * 0.1
			if FireFightersMinigameUtils.chancef(fire.size - 1.0):
				try_to_spread_fire(tile)


func try_to_spread_fire(tile: Vector2i):
	var dir: Vector2i = Vector2.from_angle(randf() * 2 * PI).round()
	var neighbor_pos := Vector2i(tile + dir)
	assert(abs(dir.x) == 1 or abs(dir.y) == 1)
	var neighbor_feature: FireFightersMapFeature = get_map_feature(tile + dir)
	if neighbor_feature and not is_tile_burning(neighbor_pos):
		if FireFightersMinigameUtils.chancef(neighbor_feature.flammability):
			add_fire(neighbor_pos)


func spawn_player():
	player = player_scene.instantiate()
	player.position = DisplayServer.window_get_size() / 2
	add_child(player)
	player.extinguish_spot.connect(on_extinguish_at)


func on_extinguish_at(pos: Vector2):
	var tile: Vector2i = tile_map_terrain.local_to_map(pos)
	if fires.has(tile):
		var fire: FireFightersMinigameFire = fires[tile]
		fire.size -= 0.1


func get_map_feature(tile: Vector2i) -> FireFightersMapFeature:
	var atlas_coords: Vector2i = tile_map_objects.get_cell_atlas_coords(tile)
	return get_map_feature_from_atlas_coords(atlas_coords)


func get_map_feature_from_atlas_coords(coords: Vector2i) -> FireFightersMapFeature:
	if coords == Vector2i(-1, -1):
		return null
	assert(map_feature_lookup.has(coords))
	return map_feature_lookup[coords]


func is_tile_burning(tile: Vector2i) -> bool:
	return fires.has(tile)
