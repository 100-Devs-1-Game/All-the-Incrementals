class_name GamePopupMenu
extends Control

@export var pause: Pause


func _on_settings_pressed() -> void:
	SceneLoader.enter_settings()


func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _on_main_menu_pressed() -> void:
	pause.try_unpause()
	SceneLoader.enter_main_menu()
