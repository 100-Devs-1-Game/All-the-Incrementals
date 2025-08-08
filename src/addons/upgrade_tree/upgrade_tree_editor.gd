@tool
extends EditorPlugin

const UpgradeTreeEditor = preload("res://addons/upgrade_tree/upgrade_tree_editor.tscn")
const UpgradeEditorScene = preload("res://addons/upgrade_tree/upgrade_editor.tscn")
const UpgradeTreeEditorVersion: int = 1
const MissingCurrentDataText: StringName = "SELECT AN UPGRADE TREE"

var upgrade_tree_editor_instance: Control
var graph_edit: GraphEdit

#FIXME: Need to handle this better when we have non-minigame trees
var current_data: MinigameData = null
var current_selected_node: GraphNode = null
var file_dialog: FileDialog

func _update_dropdown_trees():
	var dropdown: OptionButton = upgrade_tree_editor_instance.get_node("UpgradeTreeDropdown")

	var minigame_data_paths := _get_all_minigame_data("res://modules")
	dropdown.clear()

	if !current_data:
		dropdown.add_item(MissingCurrentDataText)
		dropdown.select(0)

	for path in minigame_data_paths:
		dropdown.add_item(path)

	if current_data:
		for idx in range(dropdown.item_count):
			if dropdown.get_item_text(idx) == current_data.resource_path:
				# for some reason this doesn't call the signal, so we draw the tree
				dropdown.select(idx)
				_draw_upgrade_tree(current_data)
				break


func _get_derived_classes(base_class: StringName) -> Array:
	var result := []
	var global_classes = ProjectSettings.get_global_class_list()

	for class_info in global_classes:
		print(class_info)
		if class_info.base == base_class:
			result.append(class_info.path)

	return result


func _get_class_path(name: String) -> String:
	var result := []
	var global_classes = ProjectSettings.get_global_class_list()

	for class_info in global_classes:
		print(class_info)
		if class_info.class == name:
			return class_info.path

	assert(false)
	return ""


func _get_all_minigame_data(start_path:String) -> Array[String]:
	var found_resources: Array[String] = []
	var dir := DirAccess.open(start_path)
	if not dir:
		assert(false)
		return found_resources

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			if file_name != "." and file_name != "..":
				found_resources.append_array(_get_all_minigame_data(start_path.path_join(file_name)))
		else:
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var file_path = start_path.path_join(file_name)
				var res = ResourceLoader.load(file_path)

				# sometimes there are strange errors caused by some resources
				# not being resaved after their scripts change
				# since this plugin has to load every resource to figure out
				# which ones are of the type we need
				# so when that happens, uncomment this and check to see what
				# files are changed as a result

				#var err := ResourceSaver.save(res, file_path)
				#if err != OK:
				#	push_error("%s failed to save?" % file_path)

				if res and res is MinigameData:
					found_resources.append(file_path)
		file_name = dir.get_next()

	return found_resources


func _has_main_screen() -> bool:
	return true


func _make_visible(visible: bool) -> void:
	if !upgrade_tree_editor_instance:
		return

	if visible:
		upgrade_tree_editor_instance.show()
		_update_dropdown_trees()
	else:
		upgrade_tree_editor_instance.hide()

	# stop all the upgrade nodes from updating, when we're not on that tab
	var children := graph_edit.get_children()
	for child in children:
		var upgrade_editor: UpgradeEditor = child as UpgradeEditor
		if upgrade_editor:
			upgrade_editor.set_process(visible)


func _get_plugin_name():
	return "UpgradeTree"


func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Tree", "EditorIcons")


func _enter_tree() -> void:
	upgrade_tree_editor_instance = UpgradeTreeEditor.instantiate()
	graph_edit = upgrade_tree_editor_instance.get_node("GraphEdit")
	graph_edit.snapping_enabled = true
	graph_edit.snapping_distance = 64
	graph_edit.show_grid_buttons = false
	graph_edit.right_disconnects = true
	graph_edit.zoom = graph_edit.zoom_min
	# Add the main panel to the editor's main viewport.
	EditorInterface.get_editor_main_screen().add_child(upgrade_tree_editor_instance)

	# Hide the main panel. Very much required.
	_make_visible(false)
	EditorInterface.get_inspector().edited_object_changed.connect(_on_edited_object_changed)
	upgrade_tree_editor_instance.get_node("AddUpgrade").pressed.connect(_on_add_upgrade_pressed)
	upgrade_tree_editor_instance.get_node("SaveUpgrade").pressed.connect(_on_save_upgrade_pressed)
	upgrade_tree_editor_instance.get_node("DeleteUpgrade").pressed.connect(
		_on_delete_upgrade_pressed
	)
	upgrade_tree_editor_instance.get_node("ReloadResources").pressed.connect(
		_on_reload_resources_pressed
	)
	upgrade_tree_editor_instance.get_node("UpgradeTreeDropdown").item_selected.connect(
		_on_tree_dropdown_selected
	)
	graph_edit.connection_request.connect(_on_connection_request)
	graph_edit.disconnection_request.connect(_on_disconnection_request)

	file_dialog = FileDialog.new()
	file_dialog.access = FileDialog.ACCESS_RESOURCES
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.filters = PackedStringArray(["*.tres"])
	file_dialog.file_selected.connect(_on_file_selected)
	file_dialog.name = "Save Upgrade"
	upgrade_tree_editor_instance.add_child(file_dialog)


func _exit_tree() -> void:
	if upgrade_tree_editor_instance:
		upgrade_tree_editor_instance.queue_free()


# Methods for drawing the graph


func _add_node(
	graph_edit: GraphEdit, new_upgrade: BaseUpgrade, current_node: UpgradeEditor
) -> UpgradeEditor:
	var graph_node: UpgradeEditor = UpgradeEditorScene.instantiate()
	graph_node.upgrade = new_upgrade
	graph_node.node_selected.connect(_on_upgrade_selected.bind(graph_node))
	graph_node.dragged.connect(_on_dragged.bind(graph_node))
	graph_edit.add_child(graph_node)
	if current_node:
		graph_edit.connect_node(current_node.name, 0, graph_node.name, 0)

	# force all upgrades to save on load, causing their resource data to refresh
	_save_upgrade(new_upgrade)
	return graph_node


func _draw_nodes(current_node: UpgradeEditor):
	for unlock in current_node.upgrade.unlocks:
		if not unlock:
			print("Warning: null resource in unlocks array")
			continue
		var new_node = _add_node(graph_edit, unlock, current_node)
		_draw_nodes(new_node)


#FIXME: Need to handle this better when we have non-minigame trees
func _draw_upgrade_tree(data: MinigameData) -> void:
	_clear_upgrade_tree()

	# remove any root upgrades which actually aren't root upgrades, because something unlocks them
	data.upgrade_tree_root_nodes = data.upgrade_tree_root_nodes.filter(
		func(upgrade: BaseUpgrade):
			var unlockable := _upgrade_is_unlockable(upgrade)
			return !unlockable
	)

	# remove any duplicate root upgrades
	var upgrades_found: Array[BaseUpgrade]
	data.upgrade_tree_root_nodes = data.upgrade_tree_root_nodes.filter(
		func(upgrade: BaseUpgrade):
			if !upgrades_found.has(upgrade):
				upgrades_found.append(upgrade)
				return true

			return false
	)
	upgrades_found.clear()

	for upgrade in data.upgrade_tree_root_nodes:
		if not upgrade:
			print("Warning: null resource in root upgrades array")
			continue
		var new_node = _add_node(graph_edit, upgrade, null)
		_draw_nodes(new_node)


func _clear_upgrade_tree() -> void:
	for child in graph_edit.get_children():
		if child is GraphNode:
			graph_edit.remove_child(child)
			child.queue_free()


#FIXME: Need to handle this better when we have non-minigame trees
func _save_upgrade(upgrade: MinigameUpgrade):
	if !upgrade.resource_path:
		return

	if upgrade.has_meta("tree_editor_version_added"):
		var ver := upgrade.get_meta("tree_editor_version_added")
		upgrade.set_meta("tree_editor_version_added", null) #remove, need _ prefix for editor
		upgrade.set_meta("_tree_editor_version_added", ver) #update correct meta name

	if upgrade.has_meta("tree_editor_version_saved"):
		upgrade.set_meta("tree_editor_version_saved", null) #remove, need _ prefix for editor

	upgrade.set_meta("_tree_editor_version_saved", UpgradeTreeEditorVersion)

	var result := ResourceSaver.save(upgrade)
	if result != OK:
		push_error("error saving upgrade: %s", result)
		upgrade.resource_path = ""
		return

	if !current_data:
		push_error("saved upgrade without a tree selected - unable to edit tree")
		return

	# if the node isn't unlocked by something and wasn't a root, make it a root
	var unlockable := _upgrade_is_unlockable(upgrade)
	if !unlockable && !current_data.upgrade_tree_root_nodes.has(upgrade):
		current_data.upgrade_tree_root_nodes.append(upgrade)


# Button press handlers


func _on_add_upgrade_pressed() -> void:
	#FIXME: Need to handle this better when we have non-minigame trees
	if current_data:
		var upgrade = MinigameUpgrade.new()
		# we can use this in the future to update old upgrades or something
		# a lil bit of future proofing never hurt innit
		upgrade.set_meta("tree_editor_version_added", UpgradeTreeEditorVersion)
		upgrade.name = "New Upgrade"
		upgrade.position = Vector2(0, 0)

		if current_selected_node:
			upgrade.position = current_selected_node.position_offset + Vector2(128, 128)

			var upgrade_editor_node := current_selected_node as UpgradeEditor
			if upgrade_editor_node:
				upgrade.logic = upgrade_editor_node.upgrade.logic.duplicate(false)
				upgrade.max_level = upgrade_editor_node.upgrade.max_level

		# explicitly passing null because it auto-connects and that's kinda frustrating tbh
		_add_node(graph_edit, upgrade, null)
	else:
		assert(current_data)
		push_error("No MiniGameData selected.")


func _on_save_upgrade_pressed() -> void:
	file_dialog.popup_centered()


func _try_add_root(p_upgrade: BaseUpgrade) -> bool:
	if !current_data:
		return false

	if _upgrade_is_unlockable(p_upgrade) || current_data.upgrade_tree_root_nodes.has(p_upgrade):
		return false

	current_data.upgrade_tree_root_nodes.append(p_upgrade)
	return true


func _on_delete_upgrade_pressed() -> void:
	for child in graph_edit.get_children():
		if child is UpgradeEditor:
			if current_selected_node.upgrade in child.upgrade.unlocks:
				child.upgrade.unlocks.erase(current_selected_node.upgrade)
				_save_upgrade(child.upgrade)
				graph_edit.disconnect_node(child.name, 0, current_selected_node.name, 0)
			if child.upgrade in current_selected_node.upgrade.unlocks:
				_try_add_root(child.upgrade) #todo: we could force them to connect instead?
				graph_edit.disconnect_node(current_selected_node.name, 0, child.name, 0)

	# remove it as a root if it was one. if not, then nothing happens
	current_data.upgrade_tree_root_nodes.erase(current_selected_node.upgrade)

	graph_edit.remove_child(current_selected_node)
	current_selected_node = null


func _on_reload_resources_pressed() -> void:
	_draw_upgrade_tree(current_data)


func _upgrade_has_unlockable(p_root: BaseUpgrade, p_unlockable: BaseUpgrade) -> bool:
	for unlockable in p_root.unlocks:
		# let's hope no one made an infinite loop kk?
		if unlockable == p_unlockable || _upgrade_has_unlockable(unlockable, p_unlockable):
			return true

	return false


func _upgrade_is_unlockable(p_upgrade: BaseUpgrade) -> bool:
	if !current_data:
		assert(current_data)
		push_error("no upgrade tree is currently selected")
		return false

	for root_upgrade in current_data.upgrade_tree_root_nodes:
		if _upgrade_has_unlockable(root_upgrade, p_upgrade):
			return true

	return false


func _on_file_selected(path: String) -> void:
	current_selected_node.upgrade.resource_path = ProjectSettings.localize_path(path)
	_save_upgrade(current_selected_node.upgrade)
	_draw_upgrade_tree(current_data)


func change_tree(object: Variant) -> void:
	#FIXME: Need to handle this better when we have non-minigame trees
	if object is MinigameData:
		current_data = object
		_make_visible(true)
	elif not object is BaseUpgrade:
		current_data = null
		current_selected_node = null
		_clear_upgrade_tree()
		_make_visible(false)


# Signal Handlers
func _on_edited_object_changed() -> void:
	var edited = EditorInterface.get_inspector().get_edited_object()
	change_tree(edited)


func _on_upgrade_selected(graph_node: GraphNode) -> void:
	current_selected_node = graph_node
	EditorInterface.edit_resource(graph_node.upgrade)


func _on_dragged(_old_position: Vector2, new_position: Vector2, graph_node: GraphNode) -> void:
	graph_node.upgrade.position = new_position
	_save_upgrade(graph_node.upgrade)


func _on_disconnection_request(from_node, from_port, to_node, to_port):
	upgrade_tree_editor_instance.get_node("GraphEdit")
	var from_node_instance: UpgradeEditor = graph_edit.get_node_or_null(NodePath(from_node))
	var to_node_instance: UpgradeEditor = graph_edit.get_node_or_null(NodePath(to_node))
	from_node_instance.upgrade.unlocks.erase(to_node_instance.upgrade)

	# the to_node upgrade would no longer be unlocked, so it becomes a root node
	assert(current_data)
	if current_data:
		var idx := current_data.upgrade_tree_root_nodes.find(to_node_instance.upgrade)
		if idx < 0:
			current_data.upgrade_tree_root_nodes.append(to_node_instance.upgrade)

	_save_upgrade(from_node_instance.upgrade)
	graph_edit.disconnect_node(from_node, from_port, to_node, to_port)


func _on_connection_request(from_node, from_port, to_node, to_port):
	var from_node_instance: UpgradeEditor = graph_edit.get_node_or_null(NodePath(from_node))
	var to_node_instance: UpgradeEditor = graph_edit.get_node_or_null(NodePath(to_node))

	# Don't connect to input that is already connected
	if !from_node_instance is UpgradeEditor:
		push_error("refusing to connect from an invalid node: ", from_node)
		return

	if !to_node_instance is UpgradeEditor:
		push_error("refusing to connect from %s to an invalid node: %s" % [from_node, to_node])
		return

	if !from_node_instance.upgrade.resource_path:
		push_error("refusing to connect from an unsaved upgrade: ", from_node_instance.upgrade.name)
		return

	if !to_node_instance.upgrade.resource_path:
		push_error("refusing to connect to an unsaved upgrade: ", to_node_instance.upgrade.name)
		return

	for con in graph_edit.get_connection_list():
		if con.to_node == to_node and con.to_port == to_port:
			push_warning("refusing to connect %s with %s, via port %s" % [from_node_instance.upgrade.name, to_node_instance.upgrade.name, to_port])
			return

	from_node_instance.upgrade.unlocks.append(to_node_instance.upgrade)

	# the to_node upgrade would no longer be a root node, so remove it if it was
	assert(current_data)
	if current_data:
		var idx := current_data.upgrade_tree_root_nodes.find(to_node_instance.upgrade)
		if idx >= 0:
			current_data.upgrade_tree_root_nodes.remove_at(idx)

	# todo: handle removing any other unlock?

	_save_upgrade(from_node_instance.upgrade)
	graph_edit.connect_node(from_node, from_port, to_node, to_port)


func _on_tree_dropdown_selected(index: int) -> void:
	var dropdown: OptionButton = upgrade_tree_editor_instance.get_node("UpgradeTreeDropdown")
	if dropdown.get_item_text(index) == MissingCurrentDataText:
		return

	change_tree(load(dropdown.get_item_text(index)))
