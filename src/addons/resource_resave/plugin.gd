@tool
extends EditorPlugin

const BUTTON := "Resave All Resources"
const SETTING_AUTORESAVE := "resource_resaver/auto_resave"
const SETTING_AUTORESAVE_DEFAULT_VAL := false

var button: Button

func _enter_tree() -> void:
	if not ProjectSettings.has_setting(SETTING_AUTORESAVE):
		ProjectSettings.set_setting(SETTING_AUTORESAVE, SETTING_AUTORESAVE_DEFAULT_VAL)
		ProjectSettings.set_initial_value(SETTING_AUTORESAVE, SETTING_AUTORESAVE_DEFAULT_VAL)
		ProjectSettings.set_as_basic(SETTING_AUTORESAVE, true)
		ProjectSettings.save()

	button = Button.new()
	button.text = BUTTON
	button.tooltip_text = "Manually resave all .tres and .res resources"
	button.pressed.connect(_on_resave_pressed)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, button)


func _exit_tree() -> void:
	EditorInterface.get_resource_filesystem().filesystem_changed.disconnect(_on_filesystem_changed)
	button.queue_free()


func _ready() -> void:
	EditorInterface.get_resource_filesystem().filesystem_changed.connect(_on_filesystem_changed)


func _on_resave_pressed() -> void:
	resave("Resource Resaver - Resaving all Resources")


func _on_filesystem_changed():
	autoresave("Resource Resaver - Filesystem Change, Resaving all Resources")


func _save_external_data():
	autoresave("Resource Resaver - Detected Save, Resaving all Resources")


func autoresave(msg: String) -> void:
	var autoresave_enabled := ProjectSettings.get_setting(SETTING_AUTORESAVE, SETTING_AUTORESAVE_DEFAULT_VAL)
	if autoresave_enabled:
		resave(msg)


func resave(msg: String) -> void:
	print(msg)
	GodotResourceResaver.resave_resources("res://")
