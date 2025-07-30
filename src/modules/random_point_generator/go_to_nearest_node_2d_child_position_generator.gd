class_name GoToNearestNode2dChildPositionGenerator
extends PointGenerator

#region ------------------------ PRIVATE VARS ----------------------------------

var _parent_node: Node2D
var _node_2d: Node2D

#endregion

#region ======================== SET UP METHODS ================================


func _init(new_parent_node: Node2D, new_node_2d: Node2D) -> void:
	_parent_node = new_parent_node
	_node_2d = new_node_2d


#endregion

#region ======================== PUBLIC METHODS ================================


func get_closest_node() -> Node2D:
	var children = _node_2d.get_children()
	var closett_dist = 99999
	var closest_node = children[0]

	for child in children:
		var distance = child.global_position.distance_squared_to(_parent_node.global_position)
		if distance > closett_dist:
			continue

		closett_dist = distance
		closest_node = child

	return closest_node


func get_point() -> Vector2:
	if _node_2d.get_child_count() == 0:
		return _parent_node.global_position

	return get_closest_node().global_position

#endregion
