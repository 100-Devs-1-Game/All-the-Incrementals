class_name TD2DCMDSInput
extends TD2DCMDSBase

#region ======================== PUBLIC METHODS ================================


func get_move_direction(_global_position: Vector2 = Vector2.ZERO) -> Vector2:
	return Input.get_vector("left", "right", "up", "down")

#endregion
