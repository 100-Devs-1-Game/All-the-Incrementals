class_name WTFFishDB
extends Node2D

@export_dir var directory_path: String

var _data: Dictionary[String, WTFFishData]


func get_data() -> Dictionary[String, WTFFishData]:
	return _data


func _enter_tree() -> void:
	load_fish()


func load_fish() -> void:
	_load_fish(directory_path)


func _load_fish(path: StringName) -> void:
	_data.clear()

	var files := ResourceLoader.list_directory(path)
	if files == null:
		push_error("Failed to open data directory: " + path)
		return

	for file_name in files:
		if file_name.ends_with(".tres"):
			var file_path := path.path_join(file_name)
			var data := ResourceLoader.load(file_path) as WTFFishData

			if data != null && _data.get(data.resource_path) == null:
				_data[data.resource_path] = data
				print("loaded fish at %s" % data.resource_path)
			else:
				print("failed to load fish at %s", file_path)
