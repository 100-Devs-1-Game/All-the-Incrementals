class_name FireFightersMinigame
extends BaseMinigame

@export var player_scene: PackedScene

@onready var tile_map_terrain: TileMapLayer = $"TileMapLayer Terrain"
@onready var tile_map_objects: TileMapLayer = $"TileMapLayer Objects"


func _ready() -> void:
	init()
	run()


func init():
	generate_map()


func run():
	spawn_player()


func generate_map():
	pass


func spawn_player():
	pass
