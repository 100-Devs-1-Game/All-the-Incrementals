class_name MinigameMenu
extends Control

@export var visible_on_start: bool = true
@export var minigame: BaseMinigame
@export var pause: Pause

var _is_first_run: bool = true


func _ready() -> void:
	assert(
		minigame is BaseMinigame,
		(
			"Minigame property of the MinigameSharedComponents"
			+ "/SharedBaseComponents/CanvasLayer/MinigameMenu must "
			+ "be set to your minigame node in the inspector."
		)
	)

	tree_exiting.connect(_on_tree_exiting)

	if visible_on_start:
		pause.pause()
		visible = true
	else:
		visible = false
		# Since initial menu is disabled, assume first run started.
		_is_first_run = false


func open_menu() -> void:
	pause.pause()
	visible = true


func _on_play_pressed() -> void:
	pause.try_unpause()
	visible = false
	_is_first_run = false

	if _is_first_run:
		minigame.play()
	else:
		# Reload the scene from scratch, and start again immediately.
		SceneLoader.start_minigame(minigame.data, true)


func _on_upgrades_pressed() -> void:
	minigame.open_upgrades()


func _on_exit_pressed() -> void:
	minigame.exit()


func _on_tree_exiting() -> void:
	get_tree().paused = false
