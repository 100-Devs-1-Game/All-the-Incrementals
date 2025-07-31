extends Area2D

@onready var orig_pos: Vector2 = position


func _physics_process(delta: float) -> void:
	if has_overlapping_bodies():
		var player: Node2D
		player = get_overlapping_bodies()[0]
		global_position += player.position.direction_to(global_position) * delta * 10
	else:
		position = lerp(position, orig_pos, delta)
