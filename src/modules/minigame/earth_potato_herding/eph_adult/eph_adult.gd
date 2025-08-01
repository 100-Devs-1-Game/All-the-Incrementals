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

#region ======================== PRIVATE METHODS ================================


func _on_adult_saw_spirit_body_entered(body: Node2D) -> void:
	body.queue_free()
	self.queue_free()

#endregion
