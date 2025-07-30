extends TopDown2DCharacterController

#region ======================== PRIVATE METHODS ===============================


func _on_evil_spirit_repel_area_body_entered(body: Node2D) -> void:
	body.queue_free()

#endregion
