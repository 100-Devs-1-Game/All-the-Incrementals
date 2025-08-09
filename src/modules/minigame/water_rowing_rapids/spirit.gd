@tool
extends Node2D

@export var value: int = 1
@export var damping: float = 3

var velocity: Vector2


func _draw() -> void:
	draw_rect(Rect2(-16, -16, 32, 32), Color.WHITE)
	print(damping)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	position += velocity * delta
	velocity /= 1 + (damping * delta)
