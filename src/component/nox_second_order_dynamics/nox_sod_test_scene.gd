extends Node2D

@export var mouse_pos: Vector2


func _physics_process(_delta: float) -> void:
	mouse_pos = get_viewport().get_mouse_position()
