class_name DebugPopup

extends Control

# Title for the popup
@export var title: String = "DebugPopup"

# Show the debug panel on start
@export var visible_on_start: bool = false

# Enable if this debug popup has minigame upgrades
@export var has_minigame_upgrades: bool = false

# Define debug buttons by providing the names of functions to call on press.
@export var debug_buttons: Array[DebugButton] = []

# Set this to `false` if we want DebugPopup to work on release (non-debug) builds.
# Recommended to leave this `true` so players can't cheat the final game.
var _disable_on_release: bool = false

# An array of dictionary objects with text_keycode and button properties.
var _hotkeys: Array = []

var _tree_root: TreeItem
var _tree_shortcuts: TreeItem
var _tree_callables: Dictionary = {}

var _debug_minigame_upgrades: DebugMinigameUpgrades = (
	preload("res://modules/debug/debug_minigame_upgrades.gd").new()
)


func _ready() -> void:
	# Don't allow the DebugPopup to work on release builds.
	if _disable_on_release and not OS.is_debug_build():
		visible = false
		return

	# By default, the debug popup is not visible. Press 'X' to bring it up.
	visible = visible_on_start
	position = Vector2.ZERO

	_setup_shortcuts_tree()
	_setup_debug_buttons()

	if has_minigame_upgrades:
		_setup_minigame_upgrades_buttons()


func _setup_shortcuts_tree() -> void:
	_tree_root = $Tree.create_item()
	_tree_root.set_text(0, title + " (" + get_parent().name + ")")
	_tree_shortcuts = _tree_root.create_child()
	_tree_shortcuts.set_text(0, "Navigation and functions")
	$Tree.connect("item_selected", _on_item_selected)


func _setup_minigame_upgrades_buttons() -> void:
	# Must have a minigame parent if enabling minigame upgrades
	assert(get_parent() is BaseMinigame)
	# Wait until the game scene is fully ready
	get_parent().connect("game_scene_ready", _on_game_scene_ready)


func _on_game_scene_ready() -> void:
	add_child(_debug_minigame_upgrades)
	_debug_minigame_upgrades.set_tree(_tree_callables, _tree_root)
	_debug_minigame_upgrades.setup_upgrade_items()


func _setup_debug_buttons() -> void:
	for debug_button in debug_buttons:
		var new_item = _tree_shortcuts.create_child()
		_setup_item(debug_button, new_item)


func _on_item_selected():
	var selected: TreeItem = $Tree.get_selected()
	if _tree_callables.has(selected.get_instance_id()):
		$Tree.deselect_all()
		var callable: Callable = _tree_callables[selected.get_instance_id()]
		# Why deferred?
		# As a rule of thumb, never call change_scene* during the same frame
		#  as GUI event handlers (e.g., _on_item_selected, _pressed,
		# _input_event, etc.). Always defer or delay it.
		callable.call_deferred()


func _setup_item(debug_button: DebugButton, new_item: TreeItem) -> void:
	if debug_button.func_or_path.begins_with("res://"):
		_add_change_scene_item(debug_button, new_item)
	else:
		_add_function_call_item(debug_button, new_item)


func _add_change_scene_item(debug_button: DebugButton, new_item: TreeItem) -> void:
	var scene_path = debug_button.func_or_path
	var scene_filename = scene_path.get_file()

	var item_pressed = Callable(self, "_change_scene").bind(scene_path)
	_tree_callables[new_item.get_instance_id()] = item_pressed

	if debug_button.hotkey != "":
		_hotkeys.append({"text_keycode": debug_button.hotkey, "callable": item_pressed})
		new_item.set_text(0, "[" + debug_button.hotkey + "] go to " + scene_filename)
	else:
		new_item.set_text(0, "go to " + scene_filename)


func _add_function_call_item(debug_button: DebugButton, new_item: TreeItem) -> void:
	var function_name = debug_button.func_or_path
	var item_pressed = Callable(self, "_call_function").bind(function_name)
	_tree_callables[new_item.get_instance_id()] = item_pressed
	if debug_button.hotkey != "":
		_hotkeys.append({"text_keycode": debug_button.hotkey, "callable": item_pressed})
		new_item.set_text(0, "[" + debug_button.hotkey + "] " + function_name + "()")
	else:
		new_item.set_text(0, function_name + "()")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug_popup"):
		print("Toggling the DebugPopup")
		visible = !visible
	elif event is InputEventKey and event.is_pressed():
		if visible:
			print(event)

		for hotkey in _hotkeys:
			if event.as_text_keycode().to_lower() == hotkey.text_keycode.to_lower():
				hotkey.callable.call()


func _call_function(function_name: String) -> void:
	if function_name == "":
		push_error("No function name set for debug button.")
		return

	var parent = get_parent()
	if parent == null:
		push_error("Missing parent node - cannot call function " + function_name + "()")
		return

	print("Calling " + parent.name + "." + function_name + "()")
	parent.call(function_name)


func _change_scene(scene_path: String) -> void:
	if scene_path == "":
		push_error("No scene_path defined for placeholder button target")
		return

	print("Changing scene to: " + scene_path)
	get_tree().change_scene_to_packed(load(scene_path))
