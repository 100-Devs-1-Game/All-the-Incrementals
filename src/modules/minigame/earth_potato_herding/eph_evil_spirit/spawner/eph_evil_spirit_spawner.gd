extends Spawner

#region ------------------------ PRIVATE VARS ----------------------------------

@export var _youngling_swawn_zone: Node2D

#endregion

#region ======================== PUBLIC METHODS ================================


func get_generic_spawnable_node() -> Node:
	var node = _spawnable_node_scene.instantiate() as EphEvilSprit

	node.add_state_move_direction_strategy(
		"go_to_nearest_youngling",
		(
			TD_2D_C_MDS_GoToPoint
			. new()
			. set_point_generator(
				GoToNearestNode2dChildPositionGenerator.new(node, _youngling_swawn_zone)
			)
			. update_point_on_every_call()
		)
	)

	return node

#endregion
