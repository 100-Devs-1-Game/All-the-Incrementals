@tool
extends Node2D

@export var value: int = 1
@export var damping: float = 3

var velocity: Vector2

@onready var light: PointLight2D = $PointLight2D


func _draw() -> void:
	draw_rect(Rect2(-16, -16, 32, 32), Color.WHITE)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	position += velocity * delta
	velocity /= 1 + (damping * delta)


func _on_visibility_notifier_screen_entered() -> void:
	light.enabled = true
	visible = true


func _on_visibility_notifier_screen_exited() -> void:
	light.enabled = false
	visible = false
