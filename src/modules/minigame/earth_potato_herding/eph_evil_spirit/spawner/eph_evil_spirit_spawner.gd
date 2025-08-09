extends RandomPositionSpawner

#region ------------------------ PRIVATE VARS ----------------------------------

@export var _potato_swawn_zone: Node2D
@export var _player: TopDown2DCharacterController

#endregion

#region ======================== PUBLIC METHODS ================================


func get_generic_spawnable_node() -> Node:
	var node = _spawnable_node_scene.instantiate() as EphEvilSprit

	node.add_state_move_direction_strategy(
		"go_to_nearest_youngling",
		(
			TD2DCMDSGoToPoint
			. new()
			. set_point_generator(
				GoToNearestNode2dChildPositionGenerator.new(node, _potato_swawn_zone)
			)
			. update_point_on_every_call()
		)
	)

	node.add_state_move_direction_strategy(
		"go_away_from_player",
		(
			TD2DCMDSGoToPoint
			. new()
			. set_point_generator(GoAwayFromNode2D.new(node, _player))
			. update_point_on_every_call()
		)
	)
	return node

#endregion
