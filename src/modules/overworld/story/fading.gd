@tool
extends Container

const DRAW_TOLERANCE: float = 8

@export var gradient: GradientTexture2D:
	set(new):
		if is_instance_valid(gradient):
			gradient.changed.disconnect(queue_redraw)
		gradient = new
		queue_redraw()
		if is_instance_valid(gradient):
			gradient.changed.connect(queue_redraw)

@export var scroll_value: float:
	set(new):
		scroll_value = clamp_scroll(new)
		_update_children_position()

var scroll_target_value: float = scroll_value:
	set(new):
		scroll_target_value = clamp_scroll(new)
var content_max: float
var scroll_max: float


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if is_equal_approx(scroll_value, scroll_target_value):
		return
	scroll_value = lerpf(scroll_value, scroll_target_value, delta * 8)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var modified: bool = false

		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			scroll_target_value -= (content_max - size.y) / 8 * event.factor
			modified = true
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			scroll_target_value += (content_max - size.y) / 8 * event.factor
			modified = true

		if modified:
			accept_event()
			return


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_SORT_CHILDREN:
			for c in get_children():
				if c is not Control:
					return
				var minsize := (c as Control).get_combined_minimum_size()
				var rect: Rect2 = Rect2(Vector2.ZERO, minsize)
				if c.size_flags_horizontal && SIZE_EXPAND:
					rect.size.x = max(size.x, minsize.x)
				if c.size_flags_vertical && SIZE_EXPAND:
					rect.size.y = max(size.y, minsize.y)
				fit_child_in_rect(c, rect)
				content_max = maxf(scroll_max, rect.size.y)
			scroll_max = content_max - size.y
			_update_children_position()


func _draw() -> void:
	if not gradient:
		return
	var gradient_height: int = gradient.get_height()
	var unreserved_space: Vector2 = Vector2(0, size.y)

	if scroll_value - DRAW_TOLERANCE > 0:
		draw_texture_rect(gradient, Rect2(Vector2.ZERO, Vector2(size.x, gradient_height)), false)
		unreserved_space[0] += gradient_height

	if scroll_value + DRAW_TOLERANCE < scroll_max:
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


func _update_children_position() -> void:
	for c in get_children():
		if c is not Control:
			return
		c.position.y = -scroll_value
	queue_redraw()


func clamp_scroll(value: float) -> float:
	return clampf(value, 0, scroll_max)
