class_name RandomPointGenerator
extends PointGenerator

#region ------------------------ PRIVATE VARS ----------------------------------

var _polygon: PackedVector2Array
var _polygon_bounding_box: Rect2

#endregion

#region ======================== SET UP METHODS ================================


func _init(new_polygon: PackedVector2Array, new_polygon_bounding_box: Rect2) -> void:
	_polygon = new_polygon
	_polygon_bounding_box = new_polygon_bounding_box


#endregion

#region ======================== PUBLIC METHODS ================================


## Alias of get_random_point_in_polygon
func get_point() -> Vector2:
	return get_random_point_in_polygon()


## Somewhat efficient point generator in unknown shape
func get_random_point_in_polygon() -> Vector2:
	var polygon_pos = _polygon_bounding_box.position
	var polygon_size = _polygon_bounding_box.size

	for i in range(100):
		var point = Vector2(
			randf_range(polygon_pos.x, polygon_pos.x + polygon_size.x),
			randf_range(polygon_pos.y, polygon_pos.y + polygon_size.y)
		)

		if Geometry2D.is_point_in_polygon(point, _polygon):
			return point

	return Vector2.ZERO

#endregion
