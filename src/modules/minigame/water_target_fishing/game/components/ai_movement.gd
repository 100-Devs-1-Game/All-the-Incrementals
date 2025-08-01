class_name WTFAIMovementComponent
extends Node2D

# this was one of the earliest scripts and probably the most up for change
# or at least, we're going to need another version for faster fish that
# should always be moving right when the player is moving quickly
# to give them more time with the fish on-screen so they can hit them
# otherwise with the player moving right quickly and the fish moving left quickly... won't work

enum MovementDirection { UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT }

const DIR_UP_LEFT := Vector2(-1, 1)
const DIR_UP_RIGHT := Vector2(1, 1)
const DIR_DOWN_LEFT := Vector2(-1, -1)
const DIR_DOWN_RIGHT := Vector2(1, -1)

const MOVEMENT_VECTORS: Dictionary[MovementDirection, Vector2] = {
	MovementDirection.UP_LEFT: DIR_UP_LEFT,
	MovementDirection.UP_RIGHT: DIR_UP_RIGHT,
	MovementDirection.DOWN_LEFT: DIR_DOWN_LEFT,
	MovementDirection.DOWN_RIGHT: DIR_DOWN_RIGHT,
}

@export var velocity_component: WTFVelocityComponent

@export var autorun: bool = false:
	set = set_autorun
@export var max_speed: float = 540
@export var acceleration: float = 360
@export var decceleration: float = 36
@export var min_movement_seconds: float = 0.1
@export var max_movement_seconds: float = 0.4

var _seconds_since_started_moving: float = 0
var _seconds_required_moving: float = 0

var _velocity: Vector2 = Vector2.ZERO
var _target_direction: Vector2 = Vector2.ZERO

var _last_movement_direction: MovementDirection
var _current_movement_direction: MovementDirection


func set_autorun(p_autorun: bool) -> void:
	autorun = p_autorun
	set_physics_process(autorun)


func is_moving() -> bool:
	return _seconds_since_started_moving < _seconds_required_moving


func seconds_spent_moving() -> float:
	return min(_seconds_since_started_moving, _seconds_required_moving)


func seconds_spent_idle() -> float:
	return max(_seconds_since_started_moving - _seconds_required_moving, 0)


func force_move() -> void:
	_seconds_required_moving = randf_range(min_movement_seconds, max_movement_seconds)
	_seconds_since_started_moving = 0

	_last_movement_direction = _current_movement_direction

	var random_dir = _last_movement_direction
	while random_dir == _last_movement_direction:
		random_dir = WTFUtilities.random_enum(MovementDirection)

	_current_movement_direction = random_dir
	_target_direction = MOVEMENT_VECTORS[_current_movement_direction]


func try_move() -> bool:
	if is_moving():
		return false

	force_move()

	return true


func get_internal_velocity() -> Vector2:
	return _velocity


func _ready() -> void:
	set_physics_process(autorun)


func _physics_process(delta: float) -> void:
	tick(delta)


func tick(delta: float) -> void:
	_seconds_since_started_moving += delta

	if !is_moving():
		var antivec := -_velocity.normalized() * decceleration * delta
		var combined := _velocity + antivec

		# would move in reverse, instead go minspeed in original direction
		if combined.length() > _velocity.length():
			_velocity = Vector2.ZERO
		else:
			_velocity = combined

		velocity_component.velocity = _velocity
		return

	_velocity += _target_direction.normalized() * acceleration * delta

	if _velocity.length() > max_speed:
		_velocity = _velocity.normalized() * max_speed

		velocity_component.velocity = _velocity
