class_name MinigameMenu
extends Control

@export var pause: Pause

var minigame: BaseMinigame


func _ready() -> void:
	tree_exiting.connect(_on_tree_exiting)
	visible = false  # by default, not visible until open_menu() called


func open_menu() -> void:
	visible = true
	pause.pause()


func _on_play_pressed() -> void:
	pause.try_unpause()
	visible = false
	if minigame.is_game_over():
		SceneLoader.enable_immediate_play()
		SceneLoader.start_minigame(minigame.data)


func _on_upgrades_pressed() -> void:
	minigame.open_upgrades()


func _on_exit_pressed() -> void:
	minigame.exit()


func _on_tree_exiting() -> void:
	get_tree().paused = false
