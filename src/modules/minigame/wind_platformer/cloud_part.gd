class_name WindPlatformerMinigameCloudPart
extends Area2D

var active: bool = false:
	set(b):
		active = b
		monitoring = active

@onready var orig_pos: Vector2 = position


func _physics_process(delta: float) -> void:
	if not active:
		return

	if has_overlapping_bodies():
		var player: Node2D
		player = get_overlapping_bodies()[0]
		global_position += player.position.direction_to(global_position) * delta * 10
	else:
		position = lerp(position, orig_pos, delta)
