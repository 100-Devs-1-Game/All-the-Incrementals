class_name FiniteStateMachine
extends Node

signal state_changed(new_state: StateMachineState)

@export var current_state: StateMachineState = null:
	set = set_current_state
@export var previous_state: StateMachineState = null

# will throw an error if there's no current_state
@export var allow_no_state: bool = false

# print out state changes
@export var debug: bool = false

# disable temporarily
@export var paused: bool = false

var queued_state: StateMachineState


func _ready():
	late_ready.call_deferred()


func late_ready():
	assert(
		current_state or queued_state or allow_no_state, "No FSM initial state " + get_parent().name
	)
	for state: StateMachineState in get_children():
		state.on_init()
	if queued_state:
		current_state = queued_state
		queued_state = null


func _process(delta: float):
	if current_state and not paused:
		current_state.on_process(delta)


func _physics_process(delta: float):
	if current_state:
		current_state.on_always_physics_process(delta)
		if not paused:
			current_state.on_physics_process(delta)


# has to be manually called from a Rigidbody
func on_integrate_forces(state):
	if current_state and not paused:
		current_state.on_integrate_forces(state)


func _input(event: InputEvent):
	if current_state and not paused:
		current_state.on_input(event)


func _unhandled_input(event: InputEvent):
	if current_state and not paused:
		current_state.on_unhandled_input(event)


func change_state(next_state: StateMachineState):
	if next_state:
		previous_state = current_state
		current_state = next_state
	else:
		if not allow_no_state:
			push_error("Not a valid StateMachineState")
		else:
			if current_state:
				current_state.on_exit()
				current_state.state_exited.emit()
				current_state = null


func set_current_state(next_state: StateMachineState):
	if not get_parent().is_inside_tree():
		queued_state = next_state
		return

	if current_state:
		if debug:
			var dbg_str: String = (
				get_parent().name + " State Machine exiting state " + current_state.name
			)
			print(dbg_str)
		current_state.on_exit()
		current_state.state_exited.emit()
	current_state = next_state

	if current_state:
		if debug:
			print(get_parent().name + " State Machine changing state to " + current_state.name)

		state_changed.emit(current_state)
		on_pre_enter_state()
		current_state.on_enter()
		current_state.state_entered.emit()


func cancel_state():
	assert(allow_no_state)
	change_state(null)


func on_pre_enter_state():
	pass
