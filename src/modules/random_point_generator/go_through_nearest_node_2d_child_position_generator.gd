class_name GoThroughNearestNode2dChildPositionGenerator
extends GoToNearestNode2dChildPositionGenerator

#region ------------------------ PRIVATE VARS ----------------------------------

var _overshoot: float

#endregion

#region ======================== SET UP METHODS ================================


func _init(new_parent_node: Node2D, new_node_2d: Node2D, new_overshoot: float = 0) -> void:
	super(new_parent_node, new_node_2d)
	_overshoot = new_overshoot


#endregion

#region ======================== PUBLIC METHODS ================================


func get_point() -> Vector2:
	if _node_2d.get_child_count() == 0:
		return _parent_node.global_position

	var closest_node_position = get_closest_node().global_position

	return (
		closest_node_position
		+ (_parent_node.global_position.direction_to(closest_node_position) * _overshoot)
	)

#endregion
