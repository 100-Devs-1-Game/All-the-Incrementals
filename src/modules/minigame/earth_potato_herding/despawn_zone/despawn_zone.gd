extends Area2D

#region ======================== PRIVATE METHODS ===============================


func _on_body_entered(body: Node2D) -> void:
	body = body as TopDown2DCharacterController

	body.despawn()

#endregion
