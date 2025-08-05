class_name EphEvilSprit
extends Td2dCCWithAcceleration

@export var _repel_acceleration_multiplier := 10
@export var _state_machine: StateMachine
@export var _sprite_rotation_point: Marker2D
var _current_acceleration_multipliers = {}

#region ======================== PUBLIC METHODS ================================


func stop_repel_from_player() -> void:
	_current_acceleration_multipliers["repel"] = 1
	_state_machine.change_state("go_to_nearest_youngling")


func start_repel_from_player() -> void:
	_current_acceleration_multipliers["repel"] = _repel_acceleration_multiplier
	_state_machine.change_state("go_away_from_player")


#endregion

#region ======================== PRIVATE METHODS ===============================


func _calculate_acceleration() -> Vector2:
	var base = super()

	var final = base

	for current_acceleration_multiplier in _current_acceleration_multipliers.values():
		final *= current_acceleration_multiplier

	return final


func _move(delta: float, direction: Vector2) -> void:
	super(delta, direction)

	_sprite_rotation_point.rotation = Vector2.RIGHT.angle_to(_current_velosity)

#endregion
