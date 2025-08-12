extends Node2D

@export var left: Marker2D
@export var right: Marker2D
@export var ett_evil_spirit: PackedScene

func _ready() -> void:
	var timer := Timer.new()
	timer.autostart = true
	timer.wait_time = randf_range(4.0, 12.0)
	timer.timeout.connect(spawn_spirit)
	add_child(timer)

func spawn_spirit():
	var spawn_marker = [left, right].pick_random()
	var offset := Vector2(randf_range(-120.0, 120.0), randf_range(-120.0, 120.0))

	var enemy := ett_evil_spirit.instantiate()
	enemy.global_position = spawn_marker.global_position + offset
	get_tree().current_scene.add_child(enemy)

	print("Spawn enemy at:", enemy.global_position)
