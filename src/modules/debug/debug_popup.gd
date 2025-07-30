# How to use the DebugPopup
#
# Step 1. Add the DebugPopup to your scene.
# Step 2. Go to the Inspector for DebugPopup and add elements to the
#         Debug Functions array. Each element is a string that will be used
#         to call a debug function in the parent scene.
# Step 3. Define a function debug_<name> where <name> is what you specified.
# Step 4. Run your scene.
# Step 5. Press the hotkey (default X) to load the DebugPopup.
# Step 6. Click your debug button and ensure that it executes the function
#         you defined in the parent scene.

class_name DebugPopup

extends Control

# Define debug buttons by providing the names of signals that will be emitted.
@export var debug_functions: Array[String] = []


func _ready() -> void:
	# By default, the debug popup is not visible.
	visible = false

	for function_name in debug_functions:
		var new_button = Button.new()
		new_button.text = function_name
		new_button.connect("pressed", Callable(self, "_button_pressed").bind(function_name))
		$ShortcutButtons.add_child(new_button)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug_popup"):
		print("Toggling the DebugPopup")
		visible = !visible


func _button_pressed(function_name: String) -> void:
	var parent = get_parent()
	if parent != null:
		print("Calling debug_" + function_name + "() in parent node.")
		parent.call("debug_" + function_name)
