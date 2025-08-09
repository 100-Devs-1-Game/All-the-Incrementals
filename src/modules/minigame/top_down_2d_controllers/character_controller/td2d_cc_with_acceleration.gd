class_name Td2dCCWithAcceleration
extends TopDown2DCharacterController

#region ------------------------ PRIVATE VARS ----------------------------------

@export var _base_acceleration: Vector2 = Vector2.ONE * 200.0

var _current_velosity: Vector2 = Vector2.ZERO

#endregion

#region ======================== PRIVATE METHODS ===============================


func _calculate_acceleration() -> Vector2:
	return _base_acceleration


func _move(delta: float, direction: Vector2) -> void:
	_current_velosity += delta * _calculate_acceleration() * direction

	if _current_velosity.length_squared() > _base_speed.length_squared():
		_current_velosity = _current_velosity.normalized() * _base_speed

	move_and_collide(delta * _current_velosity)

#endregion
