@tool
extends EditorPlugin

const UpgradeTreeEditor = preload("res://addons/upgrade_tree/upgrade_tree_editor.tscn")
const UpgradeEditorScene = preload("res://addons/upgrade_tree/upgrade_editor.tscn")

var upgrade_tree_editor_instance
var graph_edit: GraphEdit

#FIXME: Need to handle this better when we have non-minigame trees
var current_data: MinigameData = null
var current_selected_node: GraphNode = null
var file_dialog: FileDialog


func _has_main_screen() -> bool:
	return true


func _make_visible(visible: bool) -> void:
	if upgrade_tree_editor_instance:
		if visible:
			upgrade_tree_editor_instance.show()
		else:
			upgrade_tree_editor_instance.hide()


func _get_plugin_name():
	return "UpgradeTree"


func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Tree", "EditorIcons")


func _enter_tree() -> void:
	upgrade_tree_editor_instance = UpgradeTreeEditor.instantiate()
	graph_edit = upgrade_tree_editor_instance.get_node("GraphEdit")
	graph_edit.right_disconnects = true
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
	graph_edit.connection_request.connect(_on_connection_request)
	graph_edit.disconnection_request.connect(_on_disconnection_request)

	file_dialog = FileDialog.new()
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.access = FileDialog.ACCESS_RESOURCES
	file_dialog.filters = PackedStringArray(["*.res", "*.tres", "*.*"])
	file_dialog.file_selected.connect(_on_file_selected)
	file_dialog.name = "SaveResource"
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
	graph_node.set_fields_from_upgrade()
	graph_node.node_selected.connect(_on_upgrade_selected.bind(graph_node))
	graph_node.dragged.connect(_on_dragged.bind(graph_node))
	graph_edit.add_child(graph_node)
	if current_node:
		graph_edit.connect_node(current_node.name, 0, graph_node.name, 0)
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
	if upgrade.resource_path:
		ResourceSaver.save(upgrade)
	else:
		print("Warning: resource path not set. Changes not being saved")


# Button press handlers


func _on_add_upgrade_pressed() -> void:
	#FIXME: Need to handle this better when we have non-minigame trees
	if current_data is MinigameData:
		var upgrade = MinigameUpgrade.new()
		upgrade.name = "New Upgrade"
		if current_selected_node:
			upgrade.position = current_selected_node.position_offset + Vector2(50, 50)
		else:
			upgrade.position = Vector2(100, 100)
		_add_node(graph_edit, upgrade, null)
	else:
		push_error("No MiniGameData selected.")


func _on_save_upgrade_pressed() -> void:
	file_dialog.popup_centered()


func _on_delete_upgrade_pressed() -> void:
	for child in graph_edit.get_children():
		if child is UpgradeEditor:
			if current_selected_node.upgrade in child.upgrade.unlocks:
				child.upgrade.unlocks.erase(current_selected_node.upgrade)
				_save_upgrade(child.upgrade)
				graph_edit.disconnect_node(child.name, 0, current_selected_node.name, 0)
			if child.upgrade in current_selected_node.upgrade.unlocks:
				child.upgrade.unlocks.erase(current_selected_node.upgrade)
				graph_edit.disconnect_node(current_selected_node.name, 0, child.name, 0)
	graph_edit.remove_child(current_selected_node)
	current_selected_node = null


func _on_reload_resources_pressed() -> void:
	_draw_upgrade_tree(current_data)


func _on_file_selected(path: String) -> void:
	current_selected_node.upgrade.resource_path = ProjectSettings.localize_path(path)
	ResourceSaver.save(current_selected_node.upgrade)


# Signal Handlers


func _on_edited_object_changed() -> void:
	var edited = EditorInterface.get_inspector().get_edited_object()
	#FIXME: Need to handle this better when we have non-minigame trees
	if edited is MinigameData:
		current_data = edited
		_draw_upgrade_tree(current_data)
		_make_visible(true)
	elif not edited is BaseUpgrade:
		current_data = null
		current_selected_node = null
		_clear_upgrade_tree()
		_make_visible(false)


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
	_save_upgrade(from_node_instance.upgrade)
	graph_edit.disconnect_node(from_node, from_port, to_node, to_port)


func _on_connection_request(from_node, from_port, to_node, to_port):
	# Don't connect to input that is already connected
	for con in graph_edit.get_connection_list():
		if con.to_node == to_node and con.to_port == to_port:
			return
	var from_node_instance: UpgradeEditor = graph_edit.get_node_or_null(NodePath(from_node))
	var to_node_instance: UpgradeEditor = graph_edit.get_node_or_null(NodePath(to_node))
	from_node_instance.upgrade.unlocks.append(to_node_instance.upgrade)
	_save_upgrade(from_node_instance.upgrade)
	graph_edit.connect_node(from_node, from_port, to_node, to_port)
