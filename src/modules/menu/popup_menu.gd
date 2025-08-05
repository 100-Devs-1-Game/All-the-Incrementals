class_name GamePopupMenu
extends Control

@export var main_menu_scene: PackedScene
@export var pause: Pause

@onready var settings: Settings = $Settings


func _ready() -> void:
	settings.visible = false


func _on_settings_pressed() -> void:
	settings.visible = !settings.visible


func _input(event: InputEvent) -> void:
	if settings.visible and event.is_action_pressed("exit_menu"):
		settings.visible = !settings.visible
		# set_input_as_handled() will prevent the popup menu underneath
		# from getting closed simultaneously
		get_viewport().set_input_as_handled()
		# also note: not doing pause/unpause here because the settings
		# popup only appears after the menu popup (game is already paused)


func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _on_main_menu_pressed() -> void:
	pause.try_unpause()
	get_tree().change_scene_to_packed(main_menu_scene)
