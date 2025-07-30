@tool
extends EditorPlugin

const UpgradeTreeEditor = preload("res://addons/upgrade_tree/upgrade_tree_editor.tscn")
const UpgradeEditorScene = preload("res://addons/upgrade_tree/upgrade_editor.tscn")

var upgrade_tree_editor_instance

#FIXME: Need to handle this better when we have non-minigame trees
var current_scene: Node = null
var current_selected_node: GraphNode = null

# Editor Plugin Methods


func _handles(object: Object) -> bool:
	#FIXME: Need to handle this better when we have non-minigame trees
	return object is BaseMinigame


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
	var graph_edit = upgrade_tree_editor_instance.get_node("GraphEdit")
	graph_edit.right_disconnects = true
	# Add the main panel to the editor's main viewport.
	EditorInterface.get_editor_main_screen().add_child(upgrade_tree_editor_instance)

	# Hide the main panel. Very much required.
	_make_visible(false)
	current_scene = EditorInterface.get_edited_scene_root()
	scene_changed.connect(_on_scene_changed)
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
	var graph_edit: GraphEdit = upgrade_tree_editor_instance.get_node("GraphEdit")
	for unlock in current_node.upgrade.unlocks:
		if not unlock:
			print("Warning: null resource in unlocks array")
			continue
		var new_node = _add_node(graph_edit, unlock, current_node)
		_draw_nodes(new_node)


#FIXME: Need to handle this better when we have non-minigame trees
func _draw_upgrade_tree(scene: BaseMinigame) -> void:
	var graph_edit: GraphEdit = upgrade_tree_editor_instance.get_node("GraphEdit")
	for child in graph_edit.get_children():
		if child is GraphNode:
			graph_edit.remove_child(child)
			child.queue_free()
	for upgrade in scene.data.upgrade_tree_root_nodes:
		if not upgrade:
			print("Warning: null resource in root upgrades array")
			continue
		var new_node = _add_node(graph_edit, upgrade, null)
		_draw_nodes(new_node)


# Button press handlers


func _on_add_upgrade_pressed() -> void:
	#FIXME: Need to handle this better when we have non-minigame trees
	if current_scene is BaseMinigame:
		var upgrade = MinigameUpgrade.new()
		upgrade.name = "New Upgrade"
		if current_selected_node:
			upgrade.position = current_selected_node.position_offset + Vector2(50, 50)
		else:
			upgrade.position = Vector2(100, 100)
		_add_node(upgrade_tree_editor_instance.get_node("GraphEdit"), upgrade, null)
	else:
		push_error("No BaseMinigame scene selected.")


func _on_save_upgrade_pressed() -> void:
	pass


func _on_delete_upgrade_pressed() -> void:
	pass


func _on_reload_resources_pressed() -> void:
	_draw_upgrade_tree(current_scene)


# Signal Handlers


func _on_scene_changed(scene: Node) -> void:
	#FIXME: Need to handle this better when we have non-minigame trees
	if scene is BaseMinigame:
		current_scene = scene
		_draw_upgrade_tree(scene)
		_make_visible(true)
	else:
		current_scene = null
		current_selected_node = null
		_make_visible(false)


func _on_upgrade_selected(graph_node: GraphNode) -> void:
	current_selected_node = graph_node
	EditorInterface.edit_resource(graph_node.upgrade)


func _on_dragged(old_position: Vector2, new_position: Vector2, graph_node: GraphNode) -> void:
	graph_node.upgrade.position = new_position
	if graph_node.upgrade.resource_path:
		ResourceSaver.save(graph_node.upgrade)
	else:
		print("Warning: resource path not set. Changes not being saved")


func _on_disconnection_request(from_node, from_port, to_node, to_port):
	print("Disconnect request")


func _on_connection_request(from_node, from_port, to_node, to_port):
	var graph_edit: GraphEdit = upgrade_tree_editor_instance.get_node("GraphEdit")
	# Don't connect to input that is already connected
	for con in graph_edit.get_connection_list():
		if con.to_node == to_node and con.to_port == to_port:
			return
	upgrade_tree_editor_instance.get_node("GraphEdit").connect_node(
		from_node, from_port, to_node, to_port
	)
