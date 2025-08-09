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
var _score: int
var _minigame_shared_components: MinigameSharedComponents
var _is_game_over: bool = false
# TODO implement full functionality
var _countdown: float


func _ready() -> void:
	handle_editor_direct_start()
	_minigame_shared_components = _get_child_minigame_shared_components()
	play()
	if not SceneLoader.is_immediate_play():
		_minigame_shared_components.minigame_menu.open_menu()


func handle_editor_direct_start() -> void:
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
			SceneLoader.enable_immediate_play()
	else:
		data = SceneLoader.get_current_minigame()

	assert(
		_has_child_minigame_shared_components(),
		"Couldn't find child class of type MinigameSharedComponents in Minigame scene"
	)


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


func _get_uid() -> int:
	return ResourceLoader.get_resource_uid(data.resource_path)


# This function is called when the Play button on the minigame menu is pressed.
# It should run the minigame.
func play():
	_initialize()
	data.apply_all_upgrades(self)
	_start()


func add_score(n: int = 1):
	_score += n


func get_score() -> int:
	return _score


func get_time_left() -> float:
	return _countdown


# This function is called when the Upgrades button on the minigame menu is
# pressed.
func open_upgrades():
	print("Not yet implemented")


# This function is called when the Show highscores button on the minigame menu is
# pressed.
func show_highscores():
	var highscores = Player.get_highscores(_get_uid())
	_minigame_shared_components.minigame_highscores.open_menu(highscores)


func open_main_menu():
	_minigame_shared_components.minigame_menu.open_menu()


# Call this function when the game ends to re-open the minigame menu.
func game_over():
	_minigame_shared_components.minigame_menu.open_menu()
	Player.add_stack_to_inventory(
		EssenceStack.new(data.output_essence, int(_score * data.currency_conversion_factor))
	)
	Player.update_highscores(_get_uid(), get_score())
	_is_game_over = true


func is_game_over():
	return _is_game_over


# This function is called when the Exit minigame button is pressed.
func exit() -> void:
	# Ensure the minigame menu appears next time.
	SceneLoader.disable_immediate_play()
	# Exiting the minigame will return the player to the settlement. See the
	# scene_loader.gd file for the corresponding connect() function.
	EventBus.exit_minigame.emit()


# For debugging shortcuts, immediate quit.
func quit_game() -> void:
	get_tree().quit()


func save_game() -> void:
	SaveGameManager.save()
