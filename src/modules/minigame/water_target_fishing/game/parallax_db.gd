class_name WTFParallaxDB
extends Node2D

@export_dir var directory_path: String

var _data: Dictionary[String, WTFParallaxData]


func get_data() -> Dictionary[String, WTFParallaxData]:
	return _data


func _enter_tree() -> void:
	load_data()


func load_data() -> void:
	_load_data(directory_path)


func _load_data(path: StringName) -> void:
	assert(path)
	_data.clear()

	var files := ResourceLoader.list_directory(path)
	if files == null:
		push_error("Failed to open data directory: " + path)
		return

	for file_name in files:
		if file_name.ends_with(".tres"):
			var file_path := path.path_join(file_name)
			var data := ResourceLoader.load(file_path) as WTFParallaxData

			if data != null && _data.get(data.resource_path) == null:
				_data[data.resource_path] = data
				print("loaded parallax at %s" % data.resource_path)
			else:
				print("failed to load parallax at %s", file_path)
