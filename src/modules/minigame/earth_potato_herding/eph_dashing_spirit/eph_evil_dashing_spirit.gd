class_name EphEvilDashingSprit
extends EphEvilSprit

#region ======================== PUBLIC METHODS ================================


func stop_repel_from_player() -> void:
	_near_player = false


func start_repel_from_player() -> void:
	_near_player = true
	ungrab_youngling()


#endregion

#region ======================== PRIVATE METHODS ===============================


func _move(delta: float, direction: Vector2) -> void:
	super(delta, direction)

	_sprite_rotation_point.rotation = Vector2.RIGHT.angle_to(_current_velosity)

#endregion
