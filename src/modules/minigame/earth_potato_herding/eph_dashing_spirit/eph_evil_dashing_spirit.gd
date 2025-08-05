class_name EphEvilDashingSprit
extends Td2dCCWithAcceleration

@export var _state_machine: StateMachine
@export var _sprite_rotation_point: Marker2D

#region ======================== PUBLIC METHODS ================================


func stop_repel_from_player() -> void:
	pass


func start_repel_from_player() -> void:
	pass


#endregion

#region ======================== PRIVATE METHODS ===============================


func _move(delta: float, direction: Vector2) -> void:
	super(delta, direction)

	_sprite_rotation_point.rotation = Vector2.RIGHT.angle_to(_current_velosity)

#endregion
