class_name TD_2D_C_MDS_GoToPoint
extends TD_2D_C_MDS_Base

#region ------------------------ PRIVATE VARS ----------------------------------

var _point_generator: PointGenerator
var _close_to_point_margin: float = 10
var _current_point: Vector2 = Vector2.ZERO
var _update_point_on_every_call: bool = false

#endregion

#region ======================== PUBLIC METHODS ================================


func set_point_generator(new_point_generator: PointGenerator) -> TD_2D_C_MDS_GoToPoint:
	_point_generator = new_point_generator
	select_new_point()
	return self


func update_point_on_every_call() -> TD_2D_C_MDS_GoToPoint:
	_update_point_on_every_call = true
	return self


func select_new_point() -> void:
	_current_point = _point_generator.get_point()


func get_move_direction(global_position: Vector2 = Vector2.ZERO) -> Vector2:
	if _update_point_on_every_call or _is_close_to_current_point(global_position):
		select_new_point()

	return get_move_direction_to_point(global_position, _current_point)


func get_move_direction_to_point(
	global_position: Vector2 = Vector2.ZERO,
	go_to_point: Vector2 = Vector2.ZERO,
) -> Vector2:
	return (go_to_point - global_position).normalized()


#endregion

#region ======================== PRIVATE METHODS ===============================


func _is_close_to_current_point(global_position: Vector2) -> bool:
	return global_position.distance_squared_to(_current_point) < _close_to_point_margin ** 2

#endregion
