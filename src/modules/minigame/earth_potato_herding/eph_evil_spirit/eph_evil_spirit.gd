class_name EphEvilSprit
extends TopDown2DCharacterController

#region ======================== PRIVATE METHODS ===============================


func _on_evil_spirit_saw_player_area_area_entered(_area: Area2D) -> void:
	queue_free()

#endregion
