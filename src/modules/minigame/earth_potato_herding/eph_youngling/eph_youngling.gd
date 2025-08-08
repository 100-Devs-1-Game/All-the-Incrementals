class_name EphYoungling
extends Td2dCCWithAcceleration

@export var _time_to_grow: float = 10
@export var _state_machine: StateMachine

#region ------------------------ PUBLIC VARS -----------------------------------

var eph_adult_spawner: Spawner
var mini_game: EarthPotatoHerdingMinigame

#endregion

#region ------------------------ PRIVATE VARS ----------------------------------

var _time_young: float = 0

#endregion

#region ======================== PUBLIC METHODS ================================


func grow_up() -> void:
	eph_adult_spawner.spawn_generic_node_at_position(global_position)
	queue_free()


func start_herd_by_player() -> void:
	_state_machine.change_state("herd_by_player")


func stop_herd_by_player() -> void:
	_state_machine.change_state("free_roam")


func despawn() -> void:
	#if get_tree().get_nodes_in_group("potatoes").size() == 1:
	# Last potato standing, it's game over
	#mini_game.trigger_game_over.emit()

	self.queue_free()


#endregion

#region ======================== PRIVATE METHODS ===============================


func _ready() -> void:
	mini_game = get_tree().root.get_node("EarthPotatoHerding")


func _physics_process(delta: float) -> void:
	super(delta)
	_time_young += delta

	if _time_young >= _time_to_grow:
		_state_machine.change_state("grow_up")


func _on_youngling_saw_spirit_body_entered(body: Node2D) -> void:
	body.grab_youngling(self)  #queue_free()
	#despawn()

#endregion
