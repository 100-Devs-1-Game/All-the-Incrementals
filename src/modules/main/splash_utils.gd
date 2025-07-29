class_name SplashUtils

extends Control


func fade_in_scene(current_scene: Node, fade_time: float = 1.0) -> void:
	current_scene.modulate.a = 0.0  # invisible at start
	var tween = current_scene.get_tree().create_tween()
	tween.tween_property(current_scene, "modulate:a", 1.0, fade_time)
	await tween.finished


func fade_out_scene(current_scene: Node, fade_time: float = 1.0) -> void:
	var tween = current_scene.get_tree().create_tween()
	tween.tween_property(current_scene, "modulate:a", 0.0, fade_time)
	await tween.finished
