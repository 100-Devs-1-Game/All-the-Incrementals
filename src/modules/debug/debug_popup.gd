class_name DebugPopup

extends Control

# Show the debug panel on start
@export var visible_on_start: bool = false

# Define debug buttons by providing the names of functions to call on press.
@export var debug_buttons: Array[DebugButton] = []

# Set this to `false` if we want DebugPopup to work on release (non-debug) builds.
# Recommended to leave this `true` so players can't cheat the final game.
var _disable_on_release: bool = false

@onready var shortcut_buttons_container: GridContainer = %ShortcutButtons
@onready var upgrade_buttons_container: GridContainer = %UpgradeButtons


func _ready() -> void:
	# Don't allow the DebugPopup to work on release builds.
	if _disable_on_release and not OS.is_debug_build():
		visible = false
		return

	# By default, the debug popup is not visible. Press 'X' to bring it up.
	visible = visible_on_start
	position = Vector2.ZERO
	_setup_debug_buttons()


func _setup_debug_buttons() -> void:
	for debug_button in debug_buttons:
		var new_button = Button.new()
		_add_button(debug_button, new_button)
		shortcut_buttons_container.add_child(new_button)


func _add_button(debug_button: DebugButton, new_button: Button) -> void:
	if debug_button.func_or_path.begins_with("res://"):
		_add_change_scene_button(debug_button, new_button)
	else:
		_add_function_call_button(debug_button, new_button)


func _add_change_scene_button(debug_button: DebugButton, new_button: Button) -> void:
	var scene_path = debug_button.func_or_path
	var scene_filename = scene_path.get_file()
	new_button.connect("pressed", Callable(self, "_change_scene").bind(scene_path))
	if debug_button.hotkey != "":
		new_button.text = "[" + debug_button.hotkey + "] go to " + scene_filename
	else:
		new_button.text = "go to " + scene_filename


func _add_function_call_button(debug_button: DebugButton, new_button: Button) -> void:
	var function_name = debug_button.func_or_path
	new_button.connect("pressed", Callable(self, "_call_function").bind(function_name))
	if debug_button.hotkey != "":
		new_button.text = "[" + debug_button.hotkey + "] " + function_name + "()"
	else:
		new_button.text = function_name + "()"


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug_popup"):
		print("Toggling the DebugPopup")
		visible = !visible
	elif event is InputEventKey and event.is_pressed():
		if visible:
			print(event)
		for debug_button in debug_buttons:
			if debug_button.hotkey.to_lower() == event.as_text_keycode().to_lower():
				if debug_button.func_or_path.begins_with("res://"):
					_change_scene(debug_button.func_or_path)
				else:
					_call_function(debug_button.func_or_path)


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


func _update_upgrade_buttons():
	for child in upgrade_buttons_container.get_children():
		upgrade_buttons_container.remove_child(child)
		child.queue_free()

	if not SceneLoader.has_current_minigame():
		push_error("No MinigameData in SceneLoader")
		return

	var data: MinigameData = SceneLoader.get_current_minigame()

	for upgrade in data.get_all_upgrades():
		var button := Button.new()
		_set_upgrade_button_text(button, upgrade)
		button.pressed.connect(_on_upgrade_button_pressed.bind(button, upgrade))
		upgrade_buttons_container.add_child(button)


func _set_upgrade_button_text(button: Button, upgrade: BaseUpgrade):
	button.text = "%s Lvl %d" % [upgrade.name, upgrade.current_level + 1]


func _on_upgrade_button_pressed(button: Button, upgrade: BaseUpgrade):
	upgrade.level_up()
	if upgrade is MinigameUpgrade:
		if upgrade.logic:
			upgrade.logic._apply_effect(get_tree().current_scene, upgrade)
	else:
		assert(false, "Not implemented yet")

	_set_upgrade_button_text(button, upgrade)


func _on_upgrades_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		shortcut_buttons_container.hide()
		_update_upgrade_buttons()
		upgrade_buttons_container.show()
	else:
		upgrade_buttons_container.hide()
		shortcut_buttons_container.show()
