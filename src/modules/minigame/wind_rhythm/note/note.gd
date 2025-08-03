extends Node2D

@export var speed = 500


func _process(delta):
	position.x -= delta * speed
