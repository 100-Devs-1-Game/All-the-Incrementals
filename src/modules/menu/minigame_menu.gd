class_name MinigameMenu
extends Control

@export var pause: Pause

var minigame: BaseMinigame

@onready var label_score: Label = %"Label Score"


func _ready() -> void:
	tree_exiting.connect(_on_tree_exiting)
	visible = false  # by default, not visible until open_menu() called


func open_menu() -> void:
	visible = true
	$Title.text = minigame.data.display_name
	pause.pause()
	if minigame.is_game_over():
		label_score.show()
		label_score.text = "Score: %d" % minigame.get_score()


func _on_play_pressed() -> void:
	pause.try_unpause()
	visible = false
	if minigame.is_game_over():
		SceneLoader.enable_immediate_play()
		SceneLoader.start_minigame(minigame.data)


func _on_upgrades_pressed() -> void:
	minigame.open_upgrades()


func _on_highscores_pressed() -> void:
	visible = false
	minigame.show_highscores()


func _on_exit_pressed() -> void:
	minigame.exit()


func _on_tree_exiting() -> void:
	get_tree().paused = false
