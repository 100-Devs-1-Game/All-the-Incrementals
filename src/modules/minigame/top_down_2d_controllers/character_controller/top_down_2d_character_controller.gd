class_name TopDown2DCharacterController
extends CharacterBody2D

#region ------------------------ PRIVATE VARS ----------------------------------

@export var _base_speed: Vector2 = Vector2.ONE * 200.0
@export var _use_physics_process_to_move: bool = true
@export var _move_direction_strategy: TD_2D_C_MDS_Base:
	set = set_move_direction_strategy

var _state_move_direction_strategy_map: Dictionary[String, TD_2D_C_MDS_Base]

#endregion

#region ======================== SET UP METHODS ================================


func _ready() -> void:
	_set_up()


func _set_up() -> void:
	set_physics_process(_use_physics_process_to_move)
	assert(_move_direction_strategy != null, "Move direction strategy isn't set")


#endregion

#region ======================== PUBLIC METHODS ================================


func add_state_move_direction_strategy(
	state_name: String, new_move_direction_strategy: TD_2D_C_MDS_Base
) -> void:
	_state_move_direction_strategy_map[state_name] = new_move_direction_strategy


func change_move_direction_stategy_according_to_state(state_name: String) -> void:
	assert(_state_move_direction_strategy_map.has(state_name), "Move direction strategy isn't set")
	set_move_direction_strategy(_state_move_direction_strategy_map[state_name])


func set_move_direction_strategy(new_move_direction_strategy: TD_2D_C_MDS_Base) -> void:
	_move_direction_strategy = new_move_direction_strategy


#endregion

#region ======================== PRIVATE METHODS ===============================


func _physics_process(delta: float) -> void:
	if _use_physics_process_to_move:
		_move(delta, _get_move_direction())


func _get_move_direction() -> Vector2:
	return _move_direction_strategy.get_move_direction(self.global_position)


func _move(delta: float, direction: Vector2) -> void:
	move_and_collide(delta * _base_speed * direction)

#endregion
