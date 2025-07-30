class_name GoAwayFromNode2D
extends PointGenerator

#region ------------------------ PRIVATE VARS ----------------------------------

var _parent_node: Node2D
var _go_away_from: Node2D

#endregion

#region ======================== SET UP METHODS ================================


func _init(new_parent_node: Node2D, new_go_away_from: Node2D) -> void:
	_parent_node = new_parent_node
	_go_away_from = new_go_away_from


#endregion

#region ======================== PUBLIC METHODS ================================


func get_point() -> Vector2:
	return (
		_go_away_from.global_position
		+ (_parent_node.global_position - _go_away_from.global_position).normalized() * 10000
	)

#endregion
