class_name WindPlatformerMinigameCloudPlatform
extends AnimatableBody2D

signal removed

@export var fade_duration: float = 2.5

var speed := randf_range(-50, 50)
var fade_tween: Tween

@onready var parts: Node2D = $Parts


func _ready() -> void:
	modulate = modulate.darkened(randf_range(0.0, 0.25))


func _physics_process(delta: float) -> void:
	position.x += speed * delta


func set_parts_areas_active(b: bool):
	for part: WindPlatformerMinigameCloudPart in parts.get_children():
		part.active = b


func fade():
	if fade_tween:
		return
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_duration)
	fade_tween.tween_callback(queue_free)

	removed.emit()


func _on_player_detection_area_body_entered(_body: Node2D) -> void:
	set_parts_areas_active(true)


func _on_player_detection_area_body_exited(_body: Node2D) -> void:
	set_parts_areas_active(false)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
