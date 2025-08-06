class_name MinigameMenu
extends Control

@export var visible_on_start: bool = false
@export var pause: Pause

var minigame: BaseMinigame


func init(p_minigame: BaseMinigame) -> void:
	minigame = p_minigame
	assert(minigame != null)

	assert(
		minigame is BaseMinigame,
		(
			"Minigame property of the MinigameSharedComponents"
			+ "/SharedBaseComponents/CanvasLayer/MinigameMenu must "
			+ "be set to your minigame node in the inspector."
		)
	)

	tree_exiting.connect(_on_tree_exiting)

	visible = visible_on_start


func open_menu() -> void:
	pause.pause()
	visible = true


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
