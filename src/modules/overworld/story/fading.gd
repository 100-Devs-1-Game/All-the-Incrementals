@tool
extends ScrollContainer

@export var gradient: GradientTexture2D:
	set(new):
		if is_instance_valid(gradient):
			gradient.changed.disconnect(queue_redraw)
		gradient = new
		queue_redraw()
		if is_instance_valid(gradient):
			gradient.changed.connect(queue_redraw)


func _draw() -> void:
	print("draw")
	if not gradient:
		return
	var gradient_height: int = gradient.get_height()
	draw_texture_rect(gradient, Rect2(Vector2.ZERO, Vector2(size.x, gradient_height)), false)
	draw_rect(
		Rect2(Vector2(0, gradient_height), Vector2(size.x, size.y - gradient_height * 2)),
		Color.WHITE
	)
	draw_set_transform(Vector2.ZERO, 0, Vector2(1, -1))
	draw_texture_rect(gradient, Rect2(Vector2(0, -size.y), Vector2(size.x, gradient_height)), false)
