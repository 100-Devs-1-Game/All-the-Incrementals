extends Polygon2D

var fall_speed := 690.0

func _process(delta: float) -> void:
	global_position.y += fall_speed * delta
