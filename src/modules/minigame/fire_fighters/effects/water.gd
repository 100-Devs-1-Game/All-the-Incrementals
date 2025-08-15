class_name FireFightersMinigameWater
extends Node2D

signal disappear

@export var fade_speed_threshold: float = 50.0

var velocity: Vector2
var damping: float = 2.0
var density: float = 1.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var particles: CPUParticles2D = $CPUParticles2D


func _process(delta: float) -> void:
	position += velocity * delta

	var transparency: float = min(1, velocity.length() * 1.0 / fade_speed_threshold)
	if transparency < 1 and particles.emitting:
		particles.emitting = false
	sprite.modulate.a = transparency


func _physics_process(delta: float) -> void:
	if density <= 0:
		disappear.emit()
		queue_free()
		return

	velocity *= (1.0 - damping * delta)

	if velocity.length() < 0.05:
		disappear.emit()
		queue_free()
