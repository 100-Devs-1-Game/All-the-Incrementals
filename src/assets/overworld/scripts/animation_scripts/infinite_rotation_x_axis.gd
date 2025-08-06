extends Node3D

@export var rotation_speed_deg := 90  # Degrees per second


func _process(delta: float) -> void:
	rotate_x(deg_to_rad(rotation_speed_deg * delta))
