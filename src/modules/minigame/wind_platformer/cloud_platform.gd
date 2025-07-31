extends AnimatableBody2D

var speed := randf_range(-50, 50)


func _physics_process(delta: float) -> void:
	position.x += speed * delta
