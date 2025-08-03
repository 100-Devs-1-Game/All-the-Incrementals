class_name GamePopupMenu
extends Control

@export var main_menu_scene: PackedScene

@onready var settings: Settings = $Settings
#var _settings: Settings


func _ready() -> void:
	settings.visible = false


func _on_settings_pressed() -> void:
	settings.visible = !settings.visible


func _input(event: InputEvent) -> void:
	if settings.visible and event.is_action_pressed("toggle_popup_menu"):
		settings.visible = !settings.visible


func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)
