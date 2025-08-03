class_name FireFightersMinigameItemSpawner
extends Node

@export var item_instance_scene: PackedScene
@export var debug_items: Array[FireFightersMinigameItem]

var active_items: Array[FireFightersMinigameItem]

@onready var game: FireFightersMinigame = get_parent()
@onready var timer: Timer = $Timer


func activate():
	run()
	timer.start()


func run():
	for item in _get_all_items():
		if RngUtils.chancef(item.get_spawn_probability()):
			spawn_item(item)


func spawn_item(item_type: FireFightersMinigameItem):
	var item: FireFightersMinigameItemInstance = item_instance_scene.instantiate()
	var spawn_tile: Vector2i = game.get_random_tile()
	item.position = game.get_tile_position(spawn_tile)
	game.item_node.add_child(item)
	item.init(item_type)


func _get_all_items() -> Array[FireFightersMinigameItem]:
	return debug_items + active_items


func _on_timer_timeout() -> void:
	run()
