## Abstract class for Minigame root Node Scripts to inherit. Inherited Scripts
## should override `_start()` instead of `_ready()` to start Minigames, so the
## start procedure can be controlled from here.
class_name BaseMinigame
extends Node

signal playing

## If this is enabled override `_get_countdown_duration()`
@export var has_countdown: bool = false

## Stores a uid reference to the MinigameData Resource.
## This can be assigned manually so the Minigame scene is able to start
## directly from the Editor, even when using `_start()` as entry point.
@export var data_uid: String

var data: MinigameData
var _score: int
var _minigame_shared_components: MinigameSharedComponents
var _is_game_over: bool = false

var _countdown: Timer


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

	# to appease GuT tests
	if not SaveGameManager.world_state:
		SaveGameManager.start_game()


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


## Virtual function for cleaning up the Minigame. Inherited Scripts should
## implement this if they want to do cleanup at game end
func _game_over():
	pass


func _get_key() -> StringName:
	# https://github.com/godotengine/godot/issues/75617
	# TODO: replace with UID when this is fixed
	return data.resource_path


# This function is called when the Play button on the minigame menu is pressed.
# It should run the minigame.
func play():
	_initialize()
	data.apply_all_upgrades(self)
	_start()

	playing.emit()

	if data.music_track:
		EventBus.request_music.emit(data.music_track)
		EventBus.request_music_volume.emit(0.5)

	if has_countdown:
		start_countdown()


func add_score(n: int = 1):
	_score += n


func get_score() -> int:
	return _score


func start_countdown():
	assert(has_countdown)
	_countdown = Timer.new()

	_countdown.wait_time = _get_countdown_duration()
	assert(_countdown.wait_time > 0)

	_countdown.one_shot = true

	_countdown.timeout.connect(game_over)

	add_child(_countdown)
	_countdown.start()


func get_time_left() -> float:
	return _countdown.time_left


## virtual function
func _get_countdown_duration() -> float:
	return 0


# This function is called when the Upgrades button on the minigame menu is
# pressed.
func open_upgrades():
	SceneLoader.enter_upgrade_tree()


# This function is called when the Show highscores button on the minigame menu is
# pressed.
func show_highscores():
	var highscores = Player.get_highscores(_get_key())
	_minigame_shared_components.minigame_highscores.open_menu(highscores)


func open_main_menu():
	_minigame_shared_components.minigame_menu.open_menu()


# Call this function when the game ends to re-open the minigame menu.
func game_over():
	EventBus.request_music_volume.emit(1.0)

	Player.add_stack_to_inventory(
		EssenceStack.new(data.output_essence, int(_score * data.currency_conversion_factor))
	)
	Player.update_highscores(_get_key(), get_score())
	_is_game_over = true
	_game_over()
	_minigame_shared_components.minigame_menu.open_menu()


func is_game_over():
	return _is_game_over


func reload():
	SceneLoader.enable_immediate_play()
	SceneLoader.start_minigame(data)


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


# For debugging
func cheat_credits() -> void:
	Player.add_stack_to_inventory(EssenceStack.new(EssenceInventory.EARTH_ESSENCE, 1000))
	Player.add_stack_to_inventory(EssenceStack.new(EssenceInventory.FIRE_ESSENCE, 1000))
	Player.add_stack_to_inventory(EssenceStack.new(EssenceInventory.WATER_ESSENCE, 1000))
	Player.add_stack_to_inventory(EssenceStack.new(EssenceInventory.WIND_ESSENCE, 1000))


# For debugging
func reset_savegame() -> void:
	SaveGameManager.reset()
	reload()


func save_game() -> void:
	SaveGameManager.save()
