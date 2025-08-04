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

	assert(
		_has_child_minigame_shared_components(),
		"Couldn't find child class of type MinigameSharedComponents in Minigame scene"
	)

	_minigame_shared_components = _get_child_minigame_shared_components()

	if SceneLoader._play_minigame_instantly:
		play()
	else:
		_minigame_shared_components.minigame_menu.open_menu()


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


# This function is called when the Play button on the minigame menu is pressed.
# It should run the minigame.
func play():
	_initialize()
	_start()


func add_score(n: int = 1):
	score += n


# This function is called when the Upgrades button on the minigame menu is
# pressed.
func open_upgrades():
	print("Not yet implemented")


# Call this function when the game ends to re-open the minigame menu.
func game_over():
	_minigame_shared_components.minigame_menu.open_menu()


# This function is called when the Exit minigame button is pressed.
func exit() -> void:
	# Exiting the minigame will return the player to the settlement. See the
	# scene_loader.gd file for the corresponding connect() function.
	EventBus.exit_minigame.emit()


# For debugging shortcuts, immediate quit.
func quit_game() -> void:
	get_tree().quit()
