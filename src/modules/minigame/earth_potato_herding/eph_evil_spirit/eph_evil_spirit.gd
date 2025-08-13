class_name EphEvilSprit
extends Td2dCCWithAcceleration

@export var player_instantly_kills := true
@export var _repel_acceleration_multiplier := 10
@export var _state_machine: StateMachine
@export var _sprite_rotation_point: Marker2D
@export var _hand: Sprite2D
@export var _youngling_place: Marker2D
var _near_player: bool = false
var _grabbed_youngling: EphYoungling
var _current_acceleration_multipliers = {}

#region ======================== PUBLIC METHODS ================================


func stop_repel_from_player() -> void:
	_current_acceleration_multipliers["repel"] = 1
	_near_player = false
	_state_machine.change_state("go_to_nearest_youngling")


func start_repel_from_player() -> void:
	ungrab_youngling()
	_current_acceleration_multipliers["repel"] = _repel_acceleration_multiplier
	_near_player = true
	_state_machine.change_state("go_away_from_player")


func grab_youngling(body: EphYoungling) -> void:
	if _grabbed_youngling == null and not _near_player:
		_hand.visible = false
		_grabbed_youngling = body


func ungrab_youngling() -> void:
	if _grabbed_youngling != null:
		_hand.visible = true
		_grabbed_youngling = null
	if player_instantly_kills:
		despawn()
		return


#endregion

#region ======================== PRIVATE METHODS ===============================


func _ready() -> void:
	$SpriteRotationPoint/AnimatedSprite2D.play("default")


func _calculate_acceleration() -> Vector2:
	var base = super()

	var final = base

	for current_acceleration_multiplier in _current_acceleration_multipliers.values():
		final *= current_acceleration_multiplier

	return final


func _move(delta: float, direction: Vector2) -> void:
	super(delta, direction)

	if _grabbed_youngling:
		_grabbed_youngling.global_position = _youngling_place.global_position

	_sprite_rotation_point.rotation = Vector2.RIGHT.angle_to(_current_velosity)

#endregion
