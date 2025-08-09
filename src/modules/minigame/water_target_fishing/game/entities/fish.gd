class_name WTFFish
extends Node2D

@export var data: WTFFishData
@export var should_debug_print: bool = false
@export var min_move_after_seconds: float = 1.5
@export var max_move_after_seconds: float = 5

var gravity := Vector2(0, 200.0)
var mass := 1.0
var velocity_grav := Vector2.ZERO
var _next_move_time: float

@onready var ai_movement_component: WTFAIMovementComponent = %WtfAiMovementComponent
@onready var wave_movement_component: WTFWaveMovementComponent = %WtfWaveMovementComponent
@onready var velocity_component: WTFVelocityComponent = %WtfVelocityComponent
@onready var visuals: Node2D = %Visuals
@onready var sprite2d: AnimatedSprite2D = %AnimatedSprite2D


func _ready() -> void:
	assert(data)

	sprite2d.sprite_frames = data.texture

	# the first time is offset so it can start "instantly"
	# rather than having all fish doing nothing for min_secs
	_next_move_time = randf_range(0.0, max_move_after_seconds - min_move_after_seconds)


func _physics_process(delta: float) -> void:
	if ai_movement_component.seconds_spent_idle() > _next_move_time:
		ai_movement_component.try_move()
		_next_move_time = randf_range(min_move_after_seconds, max_move_after_seconds)

	var is_underwater := global_position.y > WTFConstants.SEALEVEL
	if is_underwater:
		# in ocean, cancel out the gravity if we had any (i.e fast sky -> ocean movement)
		# but do not reverse gravity, i.e go from ocean to sky
		velocity_grav -= gravity * mass * delta
		if velocity_grav.y < 0:
			velocity_grav.y = 0

		# only apply this stuff when underwater because fish in the sky... can't do anything? lul
		ai_movement_component.tick(delta)
		wave_movement_component.tick(delta)
	else:
		## in sky, go back down fishies
		velocity_grav += gravity * mass * delta

	# do last
	var wave_amount := wave_movement_component.get_offset(delta)
	var vel_amount := velocity_component.velocity * delta
	var grav_amount := velocity_grav * delta
	position += wave_amount + vel_amount + grav_amount


func debug_print(msg: String) -> void:
	if should_debug_print:
		print(msg)
