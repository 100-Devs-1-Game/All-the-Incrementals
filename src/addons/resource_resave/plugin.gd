@tool
extends EditorPlugin

func _ready() -> void:
	EditorInterface.get_resource_filesystem().filesystem_changed.connect(_on_filesystem_changed())


func _on_filesystem_changed():
	print("Resource Resaver - Filesystem Change, Resaving all Resources")
	_resave_resources("res://")


func _save_external_data():
	print("Resource Resaver - Detected Save, Resaving all Resources")
	# bit wordy innit
#	print(
#		"Note: Internal godot errors may appear in the output window because of the Resave\n"
#		+ "This is intentional - it indicates a Resource that did need to be resaved\n"
#		+ "Please double-check `git diff` for these resaved differences"
#	)
	_resave_resources("res://")


func _resave_resources(start_path: String) -> void:
	var dir := DirAccess.open(start_path)
	if not dir:
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var file_path := start_path.path_join(file_name)

		if dir.current_is_dir():
			if file_name != "." and file_name != "..":
				_resave_resources(file_path)
		else:
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var res = ResourceLoader.load(file_path)
				var err := ResourceSaver.save(res, file_path)
				if err != OK:
					_show_error("%s failed to resave? error=%s" % [file_path, err])

		file_name = dir.get_next()


func _show_error(err: String):
	var dialog:= AcceptDialog.new()
	dialog.dialog_text = err
	dialog.title = "Resource Resaver"
	get_editor_interface().get_editor_main_screen().add_child(dialog)
	dialog.popup_centered()

	push_error("Resource Resaver - %s" % err)
