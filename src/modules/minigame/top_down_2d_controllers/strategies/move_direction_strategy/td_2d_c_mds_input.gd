class_name TD_2D_C_MDS_Input
extends TD_2D_C_MDS_Base

#region ======================== PUBLIC METHODS ================================


func get_move_direction(_global_position: Vector2 = Vector2.ZERO) -> Vector2:
	return Input.get_vector("left", "right", "up", "down")

#endregion
