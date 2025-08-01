class_name DebugPopup

extends Control

# Define debug buttons by providing the names of functions to call on press.
@export var debug_buttons: Array[DebugButton] = []


func _ready() -> void:
	# By default, the debug popup is not visible. Press 'X' to bring it up.
	visible = false

	for debug_button in debug_buttons:
		var new_button = Button.new()
		new_button.connect(
			"pressed", Callable(self, "_button_pressed").bind(debug_button.function_name)
		)
		$ShortcutButtons.add_child(new_button)
		if debug_button.hotkey != "":
			new_button.text = "[" + debug_button.hotkey + "] " + debug_button.function_name + "()"
		else:
			new_button.text = debug_button.function_name + "()"


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug_popup"):
		print("Toggling the DebugPopup")
		visible = !visible
	elif event is InputEventKey and event.is_pressed():
		if visible:
			print(event)
		for debug_button in debug_buttons:
			if debug_button.hotkey.to_lower() == event.as_text_keycode().to_lower():
				_button_pressed(debug_button.function_name)


func _button_pressed(function_name: String) -> void:
	var parent = get_parent()
	if parent != null:
		print("Calling " + function_name + "() of the parent node.")
		parent.call(function_name)
	else:
		print("Missing parent node - cannot call function " + function_name + "()")
