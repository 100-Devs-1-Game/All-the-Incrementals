class_name EphYoungling
extends TopDown2DCharacterController

#region ------------------------ PUBLIC VARS -----------------------------------

var eph_adult_spawner: Spawner

#endregion

#region ------------------------ PRIVATE VARS ----------------------------------

@export var _time_to_grow: float = 10
@export var _state_machine: StateMachine
var _time_young: float = 0

#endregion

#region ======================== PUBLIC METHODS ================================


func grow_up() -> void:
	eph_adult_spawner.spawn_generic_node_at_position(global_position)
	queue_free()


#endregion

#region ======================== PRIVATE METHODS ===============================


func _physics_process(delta: float) -> void:
	super(delta)
	_time_young += delta

	if _time_young >= _time_to_grow:
		_state_machine.change_state("grow_up")


func _on_youndling_saw_player_area_area_entered(area: Area2D) -> void:
	_state_machine.change_state("herd_by_player")


func _on_youndling_saw_player_area_area_exited(area: Area2D) -> void:
	_state_machine.change_state("free_roam")


func _on_youndling_saw_spirit_body_entered(body: Node2D) -> void:
	body.queue_free()
	self.queue_free()

#endregion
