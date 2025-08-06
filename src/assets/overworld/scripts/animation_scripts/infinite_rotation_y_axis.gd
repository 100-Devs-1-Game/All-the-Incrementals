extends Node3D

@export var rotation_speed_deg := 1  # Degrees per second


func _process(delta: float) -> void:
	rotate_y(deg_to_rad(rotation_speed_deg * delta))
