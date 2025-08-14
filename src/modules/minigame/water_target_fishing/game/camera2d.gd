class_name WTFCamera2D
extends Camera2D

var _updated: bool = false
var _visible_rect: Rect2


func _enter_tree() -> void:
	WTFGlobals.camera = self
	process_priority = 99999
	process_physics_priority = 99999


func _exit_tree() -> void:
	WTFGlobals.camera = null


func _update() -> void:
	if _updated:
		return

	var viewport_size := get_viewport_rect().size
	_visible_rect.position = get_screen_center_position() - viewport_size * 0.5 / zoom
	_visible_rect.size = viewport_size / zoom

	_updated = true
	return


func get_visible_rect() -> Rect2:
	_update()
	return _visible_rect


func get_left() -> float:
	_update()
	return _visible_rect.position.x


func get_right() -> float:
	_update()
	return _visible_rect.end.x


func get_top() -> float:
	_update()
	return _visible_rect.position.y


func get_bottom() -> float:
	_update()
	return _visible_rect.end.y


func _process(_delta: float) -> void:
	_updated = false
	global_position = (
		WTFGlobals.player.global_position
		- Vector2(get_visible_rect().size.x / 4, get_visible_rect().size.y / 2)
	)
