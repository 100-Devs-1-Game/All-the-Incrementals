extends RandomPositionSpawner

#region ------------------------ PRIVATE VARS ----------------------------------

@export var _free_roam_area: CollisionPolygon2D
@export var _free_roam_bounding_box: Control
@export var _adult_spawner: Spawner
@export var _player: TopDown2DCharacterController

#endregion

#region ======================== PUBLIC METHODS ================================


func get_generic_spawnable_node() -> Node:
	var node = _spawnable_node_scene.instantiate() as EphYoungling
	node.eph_adult_spawner = _adult_spawner

	node.add_state_move_direction_strategy(
		"free_roam",
		TD2DCMDSGoToPoint.new().set_point_generator(
			RandomPointGenerator.new(
				_free_roam_area.get_polygon(), _free_roam_bounding_box.get_global_rect()
			)
		)
	)

	node.add_state_move_direction_strategy(
		"herd_by_player",
		(
			TD2DCMDSGoToPoint
			. new()
			. set_point_generator(GoAwayFromNode2D.new(node, _player))
			. update_point_on_every_call()
		)
	)

	return node

#endregion
