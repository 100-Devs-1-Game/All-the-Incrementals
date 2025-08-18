extends Node2D

var fall_speed := 900.0


func _process(delta: float) -> void:
	global_position.y += fall_speed * delta
