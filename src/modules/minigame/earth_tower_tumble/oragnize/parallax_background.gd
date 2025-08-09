extends Parallax2D

@export var scroll_speed: float = 50.0  # pixels per second


func _process(delta: float) -> void:
	scroll_offset.x -= scroll_speed * delta
