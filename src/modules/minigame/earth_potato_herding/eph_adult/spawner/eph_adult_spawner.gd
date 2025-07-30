extends Spawner

#region ------------------------ PRIVATE VARS ----------------------------------

@export var _busket_node: Node2D

#endregion

#region ======================== PUBLIC METHODS ================================


func get_generic_spawnable_node() -> Node:
	var node = _spawnable_node_scene.instantiate() as EphAdult

	node.bucket_node = _busket_node

	node.add_state_move_direction_strategy(
		"go_to_bucket",
		TD2DCMDSGoToPoint.new().set_point_generator(Node2DPositionGenerator.new(_busket_node))
	)

	return node

#endregion
