class_name WTFFishDB
extends Node2D

@export_dir var directory_path: String

var _data: Dictionary[String, WTFFishData]


func random() -> WTFFishData:
	return _data.values().pick_random()


func _enter_tree() -> void:
	load_fish()


func load_fish():
	_load_fish(directory_path)


func _load_fish(directory_path: StringName) -> void:
	_data.clear()

	var dir = DirAccess.open(directory_path)
	if dir == null:
		push_error("Failed to open data directory: " + directory_path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if file_name.ends_with(".tres"):
			var file_path = directory_path.path_join(file_name)
			var data = load(file_path) as WTFFishData

			if data != null && _data.get(data.resource_path) == null:
				_data[data.resource_path] = data
				print("loaded fish at %s" % data.resource_path)

		file_name = dir.get_next()
