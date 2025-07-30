@tool
extends EditorPlugin

const SETTING_NAME := "version_check/required_version"

func _get_current_version() -> String :
    return "{major}.{minor}.{patch}".format(Engine.get_version_info())

func _enter_tree() -> void:
    _register_settings()
    
    var required_version := ProjectSettings.get_setting(SETTING_NAME)
    var current_version := _get_current_version()

    # incase someone only wants to check minor and not patch
    if not current_version.begins_with(required_version):
        _show_error("This project requires Godot Version '%s'\nYou are using Godot Version '%s'" %[required_version, current_version])

func _register_settings():
    if ProjectSettings.has_setting(SETTING_NAME):
        return

    var current_version := _get_current_version()

    ProjectSettings.set_setting(SETTING_NAME, current_version)
    ProjectSettings.add_property_info({
        "name": SETTING_NAME,
        "type": TYPE_STRING,
        "hint": PROPERTY_HINT_NONE,
        "usage": PROPERTY_USAGE_DEFAULT
    })

    ProjectSettings.save()

func _show_error(err: String):
    var dialog:= AcceptDialog.new()
    dialog.dialog_text = err
    dialog.title = "Invalid Godot Version"
    get_editor_interface().get_editor_main_screen().add_child(dialog)
    dialog.popup_centered()

    push_error("Invalid Godot Version - %s" % err)
