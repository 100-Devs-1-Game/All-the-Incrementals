class_name FireFightersMinigameWater
extends Node2D

signal disappear

@export var fade_speed_threshold: float = 50.0

var velocity: Vector2
var height: float = 0.0
var damping: float = 2.0
var density: float = 1.0

@onready var sprite: Sprite2D = $Sprite2D


func _process(delta: float) -> void:
	position += velocity * delta
	sprite.modulate.a = min(1, velocity.length() * 1.0 / fade_speed_threshold)
	sprite.scale = Vector2.ONE * density


func _physics_process(delta: float) -> void:
	if density <= 0:
		disappear.emit()
		queue_free()
		return

	velocity *= (1.0 - damping * delta)

	if velocity.length() < 0.05:
		disappear.emit()
		queue_free()
