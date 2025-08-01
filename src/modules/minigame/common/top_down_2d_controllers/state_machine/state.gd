class_name State
extends Node

@export var state_name: String

#region ------------------------ PRIVATE VARS ----------------------------------

var _state_machine: StateMachine:
	set = set_state_machine
var _state_machine_owner: Node:
	set = set_state_machine_owner

var _time_in_state: float = 0

#endregion

#region ======================== SET UP METHODS ================================


func _ready() -> void:
	_set_up()


func _set_up() -> void:
	set_physics_process(false)


#region ======================== PUBLIC METHODS ================================


func set_state_machine(new_state_machine: StateMachine) -> void:
	_state_machine = new_state_machine


func set_state_machine_owner(new_state_machine_owner: Node) -> void:
	_state_machine_owner = new_state_machine_owner


func enter() -> void:
	set_physics_process(true)
	_time_in_state = 0


func exit() -> void:
	set_physics_process(false)


#endregion

#region ======================== PRIVATE METHODS ===============================


func _physics_process(delta: float) -> void:
	_time_in_state += delta

#endregion
