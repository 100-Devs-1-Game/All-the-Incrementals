class_name WTFWaveMovementComponent
extends Node2D

# mostly used to give fish some small extra movements, like up/down bobbing
# making them much less homogenous to look at

@export var autorun: bool = false:
	set = set_autorun
@export var autoupdate: bool = false
@export var autoupdate_target: Node2D
@export var speed: Vector2 = Vector2(-36, 40)
@export var random_start: bool = true

var _seconds: float


func set_autorun(p_autorun: bool) -> void:
	autorun = p_autorun
	set_physics_process(autorun)


func _ready() -> void:
	set_physics_process(autorun)

	# each component has its own offset, so they aren't in sync
	if random_start:
		_seconds = randf_range(0, 100)
		speed.x *= randf_range(0.9, 1.1)
		speed.y *= randf_range(0.9, 1.1)


func _physics_process(delta: float) -> void:
	tick(delta)
	if autoupdate:
		autoupdate_target.position += get_offset(delta)


func tick(delta: float) -> void:
	_seconds += delta


func get_offset(delta: float) -> Vector2:
	return Vector2(speed.x, sin(_seconds) * speed.y) * delta
