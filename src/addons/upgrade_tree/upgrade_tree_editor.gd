@tool
extends EditorPlugin

const UpgradeTreeEditor = preload("res://addons/upgrade_tree/upgrade_tree_editor.tscn")
const UpgradeEditorScene = preload("res://addons/upgrade_tree/upgrade_editor.tscn")

var upgrade_tree_editor_instance
var current_scene: Node = null
var current_selected_node: GraphNode = null


func _enter_tree() -> void:
	upgrade_tree_editor_instance = UpgradeTreeEditor.instantiate()
	# Add the main panel to the editor's main viewport.
	EditorInterface.get_editor_main_screen().add_child(upgrade_tree_editor_instance)

	# Hide the main panel. Very much required.
	_make_visible(false)
	current_scene = EditorInterface.get_edited_scene_root()
	scene_changed.connect(_on_scene_changed)
	upgrade_tree_editor_instance.get_node("AddUpgrade").pressed.connect(_on_add_upgrade_pressed)
	upgrade_tree_editor_instance.get_node("GraphEdit").connection_request.connect(
		_on_connection_request
	)


func _on_scene_changed(scene: Node) -> void:
	if scene is UpgradeTree:
		current_scene = scene
		_make_visible(true)
	else:
		current_scene = null
		_make_visible(false)


func _on_add_upgrade_pressed() -> void:
	print("Add Upgrade button pressed")
	if current_scene is UpgradeTree:
		var graph_node: UpgradeEditor = UpgradeEditorScene.instantiate()
		var upgrade = MinigameUpgrade.new()
		upgrade.name = "New Upgrade"
		upgrade.description = "Description of the new upgrade."
		graph_node.upgrade = upgrade
		graph_node.title = "New Upgrade"
		if current_selected_node:
			graph_node.position_offset = current_selected_node.position_offset + Vector2(10, 10)
		else:
			graph_node.position_offset = Vector2(100, 100)  # Position inside the GraphEdit
		graph_node.node_selected.connect(_on_upgrade_selected.bind(graph_node))
		upgrade_tree_editor_instance.get_node("GraphEdit").add_child(graph_node)
	else:
		push_error("No UpgradeTree scene selected.")


func _on_upgrade_selected(graph_node: GraphNode) -> void:
	if current_selected_node:
		current_selected_node.get_node("TableContainer").hide()
	current_selected_node = graph_node
	graph_node.get_node("TableContainer").show()
	EditorInterface.edit_resource(graph_node.upgrade)


func _on_connection_request(from_node, from_port, to_node, to_port):
	# Don't connect to input that is already connected
	for con in upgrade_tree_editor_instance.get_node("GraphEdit").get_connection_list():
		if con.to_node == to_node and con.to_port == to_port:
			return
	upgrade_tree_editor_instance.get_node("GraphEdit").connect_node(
		from_node, from_port, to_node, to_port
	)


func _exit_tree() -> void:
	if upgrade_tree_editor_instance:
		upgrade_tree_editor_instance.queue_free()


func _handles(object: Object) -> bool:
	return object is UpgradeTree


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
