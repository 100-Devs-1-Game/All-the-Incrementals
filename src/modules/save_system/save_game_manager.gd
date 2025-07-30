extends Node

# TODO needs testing ( GuT too? )
var world_state: WorldState


func load_game():
	var path := "user://savegame.res"
	if not FileAccess.file_exists(path):
		world_state = load("default_world_state.tres")
		world_state.resource_path = path
	else:
		world_state = load(path)


func save():
	var error: Error = ResourceSaver.save(world_state)
	assert(error == OK)
