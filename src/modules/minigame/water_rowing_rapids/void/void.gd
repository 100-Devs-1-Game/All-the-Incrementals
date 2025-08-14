extends Node2D

var speed: float = 300.0


func _physics_process(delta: float) -> void:
	position.x += speed * delta
