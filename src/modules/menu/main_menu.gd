extends Control

@onready var settings: Settings = $Settings


func _ready() -> void:
	settings.visible = false
	get_tree().paused = false


func quit_game() -> void:
	get_tree().quit()


func _on_quit_game_pressed() -> void:
	quit_game()


func _on_settings_pressed() -> void:
	settings.visible = !settings.visible


func _input(event: InputEvent) -> void:
	if settings.visible and event.is_action_pressed("exit_menu"):
		settings.visible = !settings.visible


func _on_start_pressed() -> void:
	SceneLoader.enter_shrine()


func _on_extras_pressed() -> void:
	SceneLoader.enter_extras()
