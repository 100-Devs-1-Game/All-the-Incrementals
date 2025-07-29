class_name FireFightersMinigame
extends BaseMinigame

@export var player_scene: PackedScene
@export var map_rect: Rect2i = Rect2i(0, 0, 50, 50)
@export var map_features: Array[FireFightersMapFeature]

var map_feature_lookup: Dictionary

@onready var tile_map_terrain: TileMapLayer = $"TileMapLayer Terrain"
@onready var tile_map_objects: TileMapLayer = $"TileMapLayer Objects"


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
	spawn_player()


func spawn_player():
	pass


func get_map_feature_from_coords(coords: Vector2i) -> FireFightersMapFeature:
	assert(map_feature_lookup.has(coords))
	return map_feature_lookup[coords]
