class_name EphAdult
extends TopDown2DCharacterController

@export var _close_to_bucket_margin: float = 10

#region ------------------------ PUBLIC VARS -----------------------------------

var bucket_node: Node2D

#endregion

#region ======================== PUBLIC METHODS ================================


func is_close_to_bucket() -> bool:
	return (
		global_position.distance_squared_to(bucket_node.global_position)
		< _close_to_bucket_margin ** 2
	)


func add_self_to_bucket() -> void:
	queue_free()

#endregion
