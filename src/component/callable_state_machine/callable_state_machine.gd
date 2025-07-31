class_name CallableStateMachine extends RefCounted

signal state_changed(from: Callable, to: Callable)

var states: Dictionary[StringName, Dictionary] = {}

var current_state: Callable


func add_state(
	normal: Callable, enter: Callable = Callable(), leave: Callable = Callable()
) -> void:
	var normal_name = normal.get_method()
	states[normal_name] = {}
	states[normal_name]["normal"] = normal
	if not enter.is_null():
		states[normal_name]["enter"] = enter
	if not leave.is_null():
		states[normal_name]["leave"] = leave


func set_initial_state(state: Callable) -> void:
	change_state(state, true)


func update() -> void:
	if not current_state.is_null():
		current_state.call()


func current_state_equals(state_to_check: Callable) -> bool:
	if current_state.is_null() and state_to_check.is_null():
		return true
	return (
		not current_state.is_null()
		and not state_to_check.is_null()
		and current_state.get_method() == state_to_check.get_method()
	)


func has_state(state: Callable) -> bool:
	return states.has(state)


func change_state(to_state: Callable, immediate: bool = false) -> void:
	var change := func():
		var to_state_name = to_state.get_method()
		var current_state_name: StringName = (
			current_state.get_method() if not current_state.is_null() else StringName()
		)
		if states.has(to_state_name):
			if not current_state_name.is_empty() and states[current_state_name].has("leave"):
				states[current_state_name].leave.call()
			if not current_state_name.is_empty() and states[to_state_name].has("enter"):
				states[to_state_name].enter.call()

			current_state = to_state

	if not immediate:
		change.call_deferred()
	else:
		change.call()

	state_changed.emit(current_state, to_state)
