extends Node2D

@export var left: Marker2D
@export var right: Marker2D

@export var ett_evil_spirit: PackedScene

func _ready() -> void:
	var timer = Timer.new()
	timer.autostart = true
	timer.wait_time = randf_range(4.0, 12.0)
	timer.timeout.connect(spawn_spirit)
	add_child(timer)
	timer.start()

func spawn_spirit():
	var choices = [left, right]
	var pick = choices.pick_random()
	var pos_x = randf_range(-120.0, 120.0)
	var pos_y = randf_range(-120.0, 120.0)
	var vec2 = Vector2(pos_x, pos_y)
	
	var enemy = ett_evil_spirit.instantiate()
	get_tree().current_scene.add_child(enemy)
	
	match pick:
		left:
			print("spawn enemy at: ", left.global_position + vec2)
			enemy.global_position = left.global_position + vec2
		right:
			print("spawn enemy at: ", right.global_position + vec2)
			enemy.global_position = right.global_position + vec2
