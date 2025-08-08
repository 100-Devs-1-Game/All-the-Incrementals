extends RandomPositionSpawner

#region ------------------------ PRIVATE VARS ----------------------------------

@export var _potato_swawn_zone: Node2D
#@export var _player: TopDown2DCharacterController
@export var _overshoot_potato: float = 1000

#endregion

#region ======================== PUBLIC METHODS ================================


func get_generic_spawnable_node() -> Node:
	var node = _spawnable_node_scene.instantiate() as EphEvilDashingSprit

	node.add_state_move_direction_strategy(
		"go_to_nearest_youngling",
		TD2DCMDSGoToPoint.new().set_point_generator(
			GoThroughNearestNode2dChildPositionGenerator.new(
				node, _potato_swawn_zone, _overshoot_potato
			)
		)
	)

	return node

#endregion
