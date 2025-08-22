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
	var scroll: VScrollBar = get_v_scroll_bar()
	var unreserved_space: Vector2 = Vector2(0, size.y)
	if scroll.value > 0:
		draw_texture_rect(gradient, Rect2(Vector2.ZERO, Vector2(size.x, gradient_height)), false)
		unreserved_space[0] += gradient_height
	if (scroll.value + scroll.page) < scroll.max_value:
		draw_set_transform(Vector2.ZERO, 0, Vector2(1, -1))
		draw_texture_rect(
			gradient, Rect2(Vector2(0, -size.y), Vector2(size.x, gradient_height)), false
		)
		unreserved_space[1] -= gradient_height
	draw_set_transform(Vector2.ZERO)
	draw_rect(
		Rect2(
			Vector2(0, unreserved_space[0]),
			Vector2(size.x, unreserved_space[1] - unreserved_space[0])
		),
		Color.WHITE
	)
