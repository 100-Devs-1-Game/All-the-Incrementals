class_name Node2DPositionGenerator
extends PointGenerator

#region ------------------------ PRIVATE VARS ----------------------------------

var _node_2d: Node2D

#endregion

#region ======================== SET UP METHODS ================================


func _init(new_node_2d: Node2D) -> void:
	_node_2d = new_node_2d


#endregion

#region ======================== PUBLIC METHODS ================================


func get_point() -> Vector2:
	return _node_2d.global_position

#endregion
