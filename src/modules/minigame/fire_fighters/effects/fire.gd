class_name FireFightersMinigameFire
extends Node2D

@export var offset: float = 5.0
@export var frequency: float = 10.0

@onready var orig_pos: Vector2 = position


func _process(delta: float) -> void:
	if randf() < delta * frequency:
		if not position.is_equal_approx(orig_pos):
			position = orig_pos
		else:
			position += Vector2(randf_range(-offset, offset), randf_range(-offset, offset))
