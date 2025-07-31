class_name WindPlatformerMinigameParticle

signal destroyed

var damping: float = 1.0
var life_time_range := Vector2(2.0, 7.0)

var velocity: Vector2
var position: Vector2
var life_time: float


func _init() -> void:
	life_time = randf_range(life_time_range.x, life_time_range.y)


func add_force(force: Vector2):
	velocity += force


func tick(delta: float):
	life_time -= delta
	if life_time < 0:
		destroyed.emit()
		return

	velocity *= (1 - damping * delta)
	position += velocity * delta
