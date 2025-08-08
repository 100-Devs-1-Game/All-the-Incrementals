class_name StateMachine
extends Node

#region ------------------------ PRIVATE VARS ----------------------------------

@export var _states: Array[State]
@export var _start_state: State
var _states_map: Dictionary[String, State]
var _current_state: State

#endregion

#region ======================== SET UP METHODS ================================


func _ready() -> void:
	_set_up()


func _set_up() -> void:
	_generate_state_map()
	_enter_start_state()


func _generate_state_map() -> void:
	for state in _states:
		state.set_state_machine(self)
		state.set_state_machine_owner(get_parent())
		_states_map[state.state_name] = state


func _enter_start_state() -> void:
	change_state(_start_state.state_name)


#endregion

#region ======================== PUBLIC METHODS ================================


func get_current_state_name() -> String:
	return _current_state.name


func change_state(state_name: String) -> void:
	assert(_states_map.has(state_name), "State not found")

	if _current_state != null:
		_current_state.exit()
		_current_state = null

	_current_state = _states_map[state_name]
	_current_state.enter()

#endregion
