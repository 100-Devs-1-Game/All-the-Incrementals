class_name FireFightersMinigameItemSpawner
extends Node

var game: FireFightersMinigame
var active_items: Array[FireFightersMinigameItem]

@onready var timer: Timer = $Timer


func activate():
	run()
	timer.start()


func run():
	for item in active_items:
		if RngUtils.chancef(item.get_spawn_probability):
			spawn_item(item)


func spawn_item(_item: FireFightersMinigameItem):
	pass
