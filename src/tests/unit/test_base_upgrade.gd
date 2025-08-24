extends "res://addons/gut/test.gd"


func test_variable_unlock_level_index() -> void:
	var data_list: Array = get_all_minigame_upgrades("res://modules/minigame/")
	for data: BaseUpgrade in data_list:
		assert_between(
			data.unlock_level_index,
			-1,
			data.cost_arr.size() - 1,
			(
				"unlock level index must be a valid level index(-1 to max cost_arr index)\n"
				+ data.resource_path
			)
		)


func get_all_minigame_upgrades(directory_path: String) -> Array:
	var results: Array = []
	var dir := DirAccess.open(directory_path)
	if dir == null:
		push_error("Could not open directory: " + directory_path)
		return results

	dir.include_hidden = false
	dir.include_navigational = false
	dir.list_dir_begin()

	var file_name = dir.get_next()
	while file_name != "":
		var full_path = directory_path + "/" + file_name
		if dir.current_is_dir():
			results += get_all_minigame_upgrades(full_path)
		elif file_name.ends_with(".tres"):
			var res = ResourceLoader.load(full_path)
			if res is MinigameUpgrade:
				results.append(res)
		file_name = dir.get_next()

	dir.list_dir_end()
	return results
