class_name StateMachineState
extends Node

signal state_entered
signal state_exited
signal finished


# one-time initializer when the FSM was created
func on_init():
	pass


# triggers each time the FSM switches it state to this one
func on_enter():
	pass


# _process()
func on_process(_delta: float):
	pass


# _physics_process(), but not when FSM is paused
func on_physics_process(_delta: float):
	pass


# _physics_process(), also if FSM is paused
func on_always_physics_process(_delta: float):
	pass


# has to be manually called from a Rigidbody in the FSM
func on_integrate_forces(_state):
	pass


# _input()
func on_input(_event: InputEvent):
	pass


# _unhandled_input()
func on_unhandled_input(_event: InputEvent):
	pass


# triggered when this state has finished
func on_exit():
	pass


# clears FSM current state
func cancel():
	get_state_machine().change_state(null)


# checks if the FSMs current_state is this state
func is_current_state() -> bool:
	return get_state_machine().current_state == self


func get_state_machine() -> FiniteStateMachine:
	return get_parent()
