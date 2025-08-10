class_name Extras
extends Control


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_menu"):
		SceneLoader.enter_main_menu()


func _on_credits_pressed() -> void:
	SceneLoader.enter_credits()


func _on_gallery_pressed() -> void:
	SceneLoader.enter_gallery()


func _on_back_pressed() -> void:
	SceneLoader.enter_main_menu()
