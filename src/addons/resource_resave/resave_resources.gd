class_name GodotResourceResaver
extends SceneTree

# This acts as a standalone function that can also be executed in CI by passing `--script` to godot

func _init():
	print("Resource Resaver - Running as script")
	resave_resources("res://")

static func resave_resources(start_path: String) -> void:
	var dir := DirAccess.open(start_path)
	if not dir:
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var file_path := start_path.path_join(file_name)

		if dir.current_is_dir():
			if file_name != "." and file_name != "..":
				resave_resources(file_path)
		else:
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var res = ResourceLoader.load(file_path)
				var err := ResourceSaver.save(res, file_path)
				if err != OK:
					push_error("Resource Resaver - %s failed to resave? error=%s" % [file_path, err])

		file_name = dir.get_next()
