class_name FireFightersMinigameItemSpawner
extends Node

@export var pickup_scene: PackedScene
@export var object_scene: PackedScene
@export var spawn_tries: int = 10

var active_items: Array[FireFightersMinigameItem]
var query: PhysicsShapeQueryParameters2D

@onready var game: FireFightersMinigame = get_parent()


func _ready() -> void:
	query = PhysicsShapeQueryParameters2D.new()
	query.collide_with_areas = true
	query.collision_mask = 1 + 4 + 8
	var rect_shape := RectangleShape2D.new()
	rect_shape.size = Vector2(32, 32)
	query.shape = rect_shape


func activate():
	await get_tree().physics_frame
	run()


func run():
	for item in _get_all_items():
		for n in item.spawn_amount:
			for i in spawn_tries:
				var spawn_tile: Vector2i = game.get_random_tile()
				if _can_spawn_item_on(spawn_tile):
					spawn_item(item, game.get_tile_position(spawn_tile))
					break


func spawn_item(item_type: FireFightersMinigameItem, pos: Vector2):
	var scene: PackedScene = (
		pickup_scene if item_type.type == FireFightersMinigameItem.Type.PICKUP else object_scene
	)
	var item: FireFightersMinigameItemInstance = scene.instantiate()
	item.position = pos
	game.item_node.add_child(item)
	item.init(item_type, game)


func add_item(item: FireFightersMinigameItem):
	if not item in active_items:
		active_items.append(item)


func _can_spawn_item_on(tile: Vector2i) -> bool:
	if game.has_map_feature(tile):
		return false
	query.transform.origin = game.get_tile_position(tile)
	var world := game.player.get_world_2d()
	var result := world.direct_space_state.intersect_shape(query)
	return result.is_empty()


func _get_all_items() -> Array[FireFightersMinigameItem]:
	return active_items
