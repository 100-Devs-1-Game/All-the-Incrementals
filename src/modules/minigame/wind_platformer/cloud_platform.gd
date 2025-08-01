class_name WindPlatformerMinigameCloudPlatform
extends AnimatableBody2D

var speed := randf_range(-50, 50)

@onready var parts: Node2D = $Parts


func _physics_process(delta: float) -> void:
	position.x += speed * delta


func set_parts_areas_active(b: bool):
	for part: WindPlatformerMinigameCloudPart in parts.get_children():
		part.active = b


func _on_player_detection_area_body_entered(_body: Node2D) -> void:
	set_parts_areas_active(true)


func _on_player_detection_area_body_exited(_body: Node2D) -> void:
	set_parts_areas_active(false)
