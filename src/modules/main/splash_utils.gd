class_name SplashUtils

extends Control


func fade_in_scene(current_scene: Node, fade_time: float = 1.0) -> void:
	current_scene.modulate.a = 0.0  # invisible at start
	if !current_scene or !current_scene.is_inside_tree():
		# current_scene could be null if splash screens are skipped
		return
	var tween = current_scene.get_tree().create_tween()
	tween.tween_property(current_scene, "modulate:a", 1.0, fade_time)
	await tween.finished


func fade_out_scene(current_scene: Node, fade_time: float = 1.0) -> void:
	if !current_scene or !current_scene.is_inside_tree():
		# current_scene could be null if splash screens are skipped
		return
	var tween = current_scene.get_tree().create_tween()
	tween.tween_property(current_scene, "modulate:a", 0.0, fade_time)
	await tween.finished
