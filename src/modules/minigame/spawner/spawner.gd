class_name Spawner
extends Node

#region ------------------------ PRIVATE VARS ----------------------------------

@export var _spawnable_node_scene: PackedScene
@export var _add_child_to: Node
@export var _max_spawned_total: int = -1
@export var _max_spawned_at_once: int = -1
@export var _use_physics_process_to_spawn: bool = true
@export var _spawn_cooldown: float = 10

var _spawned_total: int = 0
var _time_since_last_spawn: float = 0

#endregion

#region ======================== SET UP METHODS ================================


func _ready() -> void:
	_set_up()


func _set_up() -> void:
	set_physics_process(_use_physics_process_to_spawn)


#endregion

#region ======================== PUBLIC METHODS ================================


func get_generic_spawnable_node() -> Node:
	var node = _spawnable_node_scene.instantiate()

	return node


func spawn() -> void:
	spawn_generic_node_at_position(Vector2.ZERO)


func spawn_generic_node_at_position(global_position: Vector2) -> void:
	spawn_at_position(get_generic_spawnable_node(), global_position)


func spawn_at_position(node: Node, global_position: Vector2) -> void:
	if _max_spawned_at_once >= 0 and _add_child_to.get_child_count() >= _max_spawned_at_once:
		node.queue_free()
		return

	if _max_spawned_total >= 0 and _spawned_total >= _max_spawned_total:
		node.queue_free()
		return

	_spawned_total += 1
	node.global_position = global_position
	_add_child_to.add_child(node)


#endregion

#region ======================== PRIVATE METHODS ===============================


func _physics_process(delta: float) -> void:
	if _use_physics_process_to_spawn:
		_time_since_last_spawn -= delta
		_try_spawn()


func _try_spawn() -> void:
	if _time_since_last_spawn > 0:
		return

	_time_since_last_spawn = _spawn_cooldown

	spawn()

#endregion
