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

var player_movement_multiplier: float = 0.5
var base_speed: float = 0

var _seconds_since_started_moving: float = 0
var _seconds_required_moving: float = 0

var _velocity: Vector2 = Vector2.ZERO
var _target_direction: Vector2 = Vector2.ZERO

var _last_movement_direction: MovementDirection
var _current_movement_direction: MovementDirection

var _player_movespeed_on_spawn: float = 0


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

	var random_dir := _last_movement_direction
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


func provide(p_data: WTFFishData) -> void:
	player_movement_multiplier = p_data.player_movement_multiplier
	base_speed = p_data.base_speed

	var rnd := randf_range(0.8, 1.2)
	max_speed *= rnd
	acceleration *= rnd
	base_speed *= rnd
	player_movement_multiplier *= rnd
	player_movement_multiplier = min(max(0.2, player_movement_multiplier), 0.8)
	_player_movespeed_on_spawn = -WTFGlobals.minigame.stats.scrollspeed.x


func _physics_process(delta: float) -> void:
	tick(delta)


func tick(delta: float) -> void:
	_seconds_since_started_moving += delta

	# keep fish onscreen for longer
	var player_movement := -WTFGlobals.minigame.stats.scrollspeed.x * player_movement_multiplier

	if !is_moving():
		var antivec := -_velocity.normalized() * decceleration * delta
		var combined := _velocity + antivec

		# would move in reverse, instead go minspeed in original direction
		if combined.length() > _velocity.length():
			_velocity = Vector2.ZERO
		else:
			_velocity = combined
	else:
		_velocity += _target_direction.normalized() * acceleration * delta

		if _velocity.length() > max_speed:
			_velocity = _velocity.normalized() * max_speed

	velocity_component.velocity = (_velocity + Vector2(player_movement, 0) + Vector2(base_speed, 0))

	#if velocity_component.velocity.x > 0:
	#	velocity_component.velocity.x = max(
	#		velocity_component.velocity.x,
	#		_player_movespeed_on_spawn - 1920
	#	)

	# keep the fish onscreen for one second at least...? maybe?
	# velocity = pixels per second, 2000 = nearly screen width
	#var delta_speed := -WTFGlobals.minigame.stats.scrollspeed.x - velocity_component.velocity.x
	#delta_speed = max(delta_speed, 2000)
	#velocity_component.velocity += Vector2(delta_speed - 2000, 0)
