extends Node2D

@export var left: Marker2D
@export var right: Marker2D

@export var enemies: Array[PackedScene] = []

func spawn_spirit():
	var choices = [left, right]
	var pick = choices.pick_random()
	
	match pick:
		left:
			print("spawn enemy at: ", left.global_position)
		right:
			print("spawn enemy at: ", right.global_position)
