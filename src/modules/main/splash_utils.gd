class_name SplashUtils
extends Control

var _current_tween: Tween


func _exit_tree() -> void:
	if is_instance_valid(_current_tween):
		_current_tween.free.call_deferred()
		return


func fade_in_scene(current_scene: Node, fade_time: float = 1.0) -> void:
	current_scene.modulate.a = 0.0  # invisible at start
	# current_scene could be null if splash screens are skipped
	if !current_scene:
		return

	if !current_scene.is_inside_tree():
		current_scene.queue_free()
		return

	_current_tween = current_scene.create_tween()
	_current_tween.tween_property(current_scene, "modulate:a", 1.0, fade_time)
	await _current_tween.finished


func fade_out_scene(current_scene: Node, fade_time: float = 1.0) -> void:
	# current_scene could be null if splash screens are skipped
	if !current_scene:
		return

	if !current_scene.is_inside_tree():
		current_scene.queue_free()
		return

	_current_tween = current_scene.create_tween()
	_current_tween.tween_property(current_scene, "modulate:a", 0.0, fade_time)
	await _current_tween.finished
