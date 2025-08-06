class_name FireFightersMinigameItemSpawner
extends Node

@export var pickup_scene: PackedScene
@export var object_scene: PackedScene
@export var debug_items: Array[FireFightersMinigameItem]
@export var spawn_tries: int = 10

var active_items: Array[FireFightersMinigameItem]

@onready var game: FireFightersMinigame = get_parent()
@onready var timer: Timer = $Timer


func activate():
	run()
	timer.start()


func run():
	for item in _get_all_items():
		if RngUtils.chancef(item.spawn_probability):
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
	item.init(item_type)


func _can_spawn_item_on(_tile: Vector2i) -> bool:
	return true


func _get_all_items() -> Array[FireFightersMinigameItem]:
	return debug_items + active_items


func _on_timer_timeout() -> void:
	run()
