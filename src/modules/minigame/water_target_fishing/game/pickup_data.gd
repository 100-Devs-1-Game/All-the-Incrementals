class_name WTFPickupData
extends Resource

@export var pixels_per_second: float
@export var weight: float
@export var score: float


func get_velocity_change() -> Vector2:
	return Vector2(-pixels_per_second, 0)
