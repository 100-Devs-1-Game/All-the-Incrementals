extends TopDown2DCharacterController

#region ======================== PRIVATE METHODS ===============================

const BASE_PLAYER_SPEED = Vector2(300.0, 300.0)


func _ready() -> void:
	get_tree().root.connect("spirit_keeper_speed", _on_player_speed_changed)


func _on_evil_spirit_repel_area_body_entered(body: Node2D) -> void:
	body.queue_free()


func _on_player_speed_changed(modifier: float):
	_base_speed.x = BASE_PLAYER_SPEED.x * modifier
	_base_speed.y = BASE_PLAYER_SPEED.y * modifier

#endregion
