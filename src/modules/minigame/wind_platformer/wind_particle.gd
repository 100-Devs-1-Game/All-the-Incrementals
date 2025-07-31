class_name WindPlatformerMinigameParticle
extends Node2D

signal destroyed

@export var damping: float = 1.0
@export var life_time := Vector2(2.0, 7.0)

var velocity: Vector2

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.start(randf_range(life_time.x, life_time.y))


func add_force(force: Vector2):
	velocity += force


func tick(delta: float):
	velocity *= (1 - damping * delta)
	position += velocity * delta


func destroy():
	destroyed.emit()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	destroy()


func _on_timer_timeout() -> void:
	destroy()
