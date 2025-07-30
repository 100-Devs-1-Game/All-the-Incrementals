extends State

#region ======================== PUBLIC METHODS ================================


func enter() -> void:
	super()
	_state_machine_owner = _state_machine_owner as EphAdult
	_state_machine_owner.change_move_direction_stategy_according_to_state(state_name)


#endregion

#region ======================== PRIVATE METHODS ===============================


func _physics_process(delta: float) -> void:
	super(delta)
	if _state_machine_owner.is_close_to_bucket():
		_state_machine_owner.add_self_to_bucket()

#endregion
