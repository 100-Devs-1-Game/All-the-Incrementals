## Abstract class for Minigame root Node Scripts to inherit. Inherited Scripts
## should override `_start()` instead of `_ready()` to start Minigames, so the
## start procedure can be controlled from here.
class_name BaseMinigame
extends Node

## Stores a uid reference to the MinigameData Resource.
## This can be assigned manually so the Minigame scene is able to start
## directly from the Editor, even when using `_start()` as entry point.
@export var data_uid: String

var data: MinigameData
var score: int

var _minigame_shared_components: MinigameSharedComponents


func _ready() -> void:
	if not SceneLoader.has_current_minigame():
		# Assumes this Minigame scene was started directly from the Editor
		# Use workaround to set references as they would have been
		# if the SceneLoader had been used
		push_warning("Detected direct Minigame start")
		if data_uid.is_empty():
			push_error("No data_uid set in the Minigame scene")
			assert(false)
		else:
			data = load(data_uid)
			SceneLoader._current_minigame = data
	else:
		data = SceneLoader.get_current_minigame()

	#
	# Make sure the Minigame scene has a instance of
	# "res://modules/minigame/common/shared/minigame_shared_components.tscn"
	#
	assert(
		_has_child_minigame_shared_components(),
		"Couldn't find child class of type MinigameSharedComponents in Minigame scene"
	)

	_minigame_shared_components = _get_child_minigame_shared_components()

	if SceneLoader._play_minigame_instantly:
		on_start_button_pressed()
	else:
		open_menu()


func _has_child_minigame_shared_components() -> bool:
	for child in get_children():
		if child is MinigameSharedComponents:
			return true
	return false


func _get_child_minigame_shared_components() -> MinigameSharedComponents:
	for child in get_children():
		if child is MinigameSharedComponents:
			return child
	assert(false, "Unable to find MinigameSharedComponents")
	return


## Virtual function for initializing the Minigame. Inherited Scripts should
## use this instead of `_init()` or `_ready()`, for any initialization logic
## that can be run before the Minigame starts.
func _initialize():
	pass


## Virtual function for starting the Minigame. Inherited Scripts should
## use this instead of `_ready()`.
func _start():
	pass


func open_menu():
	_minigame_shared_components.open_main_menu()

	# TODO
	# Replace with
	# _minigame_shared_components.minigame_menu.play.pressed.connect(func(): on_start_button_pressed)
	on_start_button_pressed()


func on_start_button_pressed():
	_initialize()
	_start()


func add_score(n: int = 1):
	score += n


func game_over():
	get_tree().paused = true
	# TODO make sure the Menus don't inherit pause mode but always run

	# Minigame doesn't exit on game over anymore
	#
	#TODO
	# _minigame_shared_components.minigame_menu.open()
	#
	# Trigger reload of the Minigame scene to reset everyting and the play instantly
	# _minigame_shared_components.minigame_menu.play.pressed.connect
	#		(SceneLoader.start_minigame.bind(data, true))
	# _minigame_shared_components.minigame_menu.exit.pressed.connect
	#		(EventBus.exit_minigame.emit)


func exit() -> void:
	print("Emitting exit_minigame signal")
	EventBus.emit_signal(EventBus.exit_minigame.get_name())


func quit_game() -> void:
	get_tree().quit()
