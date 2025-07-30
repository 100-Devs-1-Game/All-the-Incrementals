extends State

#region ======================== PUBLIC METHODS ================================


func enter() -> void:
	super()
	_state_machine_owner = _state_machine_owner as TopDown2DCharacterController
	_state_machine_owner.grow_up()

#endregion
