extends Control

@onready var background: AnimatedSprite2D = %Background


func _ready() -> void:
	get_tree().paused = false
	background.play()


func quit_game() -> void:
	get_tree().quit()


func _on_quit_game_pressed() -> void:
	quit_game()


func _on_settings_pressed() -> void:
	SceneLoader.enter_settings()


func _on_start_pressed() -> void:
	SceneLoader.enter_shrine()


func _on_extras_pressed() -> void:
	SceneLoader.enter_extras()
