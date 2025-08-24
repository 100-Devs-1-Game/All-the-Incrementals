extends Node

const SAVE_PATH = "user://savegame.tres"
const SAVE_GAME_VERSION = 1

var world_state: WorldState


func start_game():
	if not FileAccess.file_exists(SAVE_PATH):
		world_state = load("res://modules/save_system/default_world_state.tres").duplicate(true)
		world_state.resource_path = SAVE_PATH
		world_state.player_state = (
			load("res://modules/save_system/default_player_state.tres").duplicate(true)
		)
		save()
	else:
		var tmp_world_state: WorldState = load(SAVE_PATH)
		if tmp_world_state.save_game_version < SAVE_GAME_VERSION:
			push_warning("Detected old save game version. Deleting file!")
			tmp_world_state = null
			reset()
			return

		world_state = tmp_world_state

	EventBus.game_loaded.emit(world_state)


func reset():
	var dir = DirAccess.open("user://")
	if dir.file_exists(SAVE_PATH):
		var error = dir.remove(SAVE_PATH)
		assert(error == OK)
	start_game()


func save():
	world_state.save_game_version = SAVE_GAME_VERSION
	var error: Error = ResourceSaver.save(world_state)
	assert(error == OK)
