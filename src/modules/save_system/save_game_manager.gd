extends Node
#
# TODO needs testing ( unit test too? )
#
#

var world_state: WorldState


func load_game():
	var path := "user://savegame.res"
	if not FileAccess.file_exists(path):
		world_state = load("default_world_state.tres").duplicate()
		world_state.resource_path = path
		world_state.player_state = load("default_player_state.tres").duplicate()
	else:
		world_state = load(path)

	EventBus.game_loaded.emit(world_state)


func save():
	var error: Error = ResourceSaver.save(world_state)
	assert(error == OK)
