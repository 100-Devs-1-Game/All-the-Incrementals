extends ColorRect


func _draw() -> void:
	get_tree().current_scene.on_draw(self)
