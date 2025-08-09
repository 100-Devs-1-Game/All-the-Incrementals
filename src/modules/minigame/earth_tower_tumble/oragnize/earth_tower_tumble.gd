class_name EarthTowerTumbleMinigame
extends BaseMinigame

signal game_started

var state

func _initialize():
	state = TowerTumbleState.new()
	get_tree().get_first_node_in_group("ui").set_state(state)

func _start():
	game_started.emit()
