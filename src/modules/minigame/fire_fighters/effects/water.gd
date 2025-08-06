class_name FireFightersMinigameWater
extends Node2D

signal disappear

@export var fade_speed_threshold: float = 50.0
@export var gravity: float = 10.0

var velocity: Vector2
var z_velocity: float
var height: float = 0.0
var damping: float = 2.0
var density: float = 1.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var particles: CPUParticles2D = $CPUParticles2D


func _process(delta: float) -> void:
	position += velocity * delta
	z_velocity += -gravity * delta
	height = clampf(height + z_velocity * delta, 0, 100)
	height = max(0, height)

	var transparency: float = min(1, velocity.length() * 1.0 / fade_speed_threshold)
	if transparency < 1 and particles.emitting:
		particles.emitting = false
	sprite.modulate.a = transparency

	sprite.scale = Vector2.ONE * density * sqrt(height + 1)


func _physics_process(delta: float) -> void:
	if density <= 0:
		disappear.emit()
		queue_free()
		return

	velocity *= (1.0 - damping * delta)

	if velocity.length() < 0.05:
		disappear.emit()
		queue_free()


func is_low() -> bool:
	return is_zero_approx(height)
