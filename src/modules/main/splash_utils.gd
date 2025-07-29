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


func crossfade_scene(current_scene: Node, new_scene_path: String, fade_time: float = 1.0) -> void:
	var old_scene = current_scene
	var new_scene = load(new_scene_path).instantiate()
	current_scene.get_tree().root.add_child(new_scene)
	new_scene.modulate.a = 0.0  # invisible at start

	var tween = current_scene.get_tree().create_tween()
	tween.tween_property(old_scene, "modulate:a", 0.0, fade_time)
	tween.tween_property(new_scene, "modulate:a", 1.0, fade_time)
	await tween.finished

	old_scene.queue_free()
	current_scene.get_tree().current_scene = new_scene
