class_name WindPlatformerMinigamePlayer
extends CharacterBody2D

signal left_screen

@export var move_speed: float = 100.0
@export var acceleration: float = 100.0
@export var max_jump_speed: float = 150.0
@export var jump_speed_per_frame: float = 10.0

@export var air_control: float = 0.25
@export var wind_impact: float = 1.0
@export var gravity: float = 100.0
@export var damping: float = 0.5
@export var start_y_velocity = 50.0

var current_cloud: WindPlatformerMinigameCloudPlatform
var current_jump_speed: float

var move_speed_factor: float = 1.0
var dive_control: float = 0.0
var air_control_bonus: float = 0.0
var jump_speed_bonus: float = 0.0

var _is_running: bool = false
var _is_on_ground: bool = false

@onready var head: Polygon2D = %Head
@onready var hat: Polygon2D = %Hat

@onready var game: WindPlatformerMinigame = get_parent()
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_run: AudioStreamPlayer = $"Audio/AudioStreamPlayer Run"
@onready var run_audio_delay: Timer = $"Audio/Run Audio Delay"


func _ready() -> void:
	velocity.y = start_y_velocity
	animated_sprite.play("falling")


func _physics_process(delta: float) -> void:
	velocity *= (1 - damping * delta)

	_is_on_ground = is_on_floor()

	if _is_on_ground and not get_last_slide_collision():
		push_warning("On ground without slide collision")

	if _is_on_ground and get_last_slide_collision() != null:
		var platform: WindPlatformerMinigameCloudPlatform = (
			get_last_slide_collision().get_collider()
		)
		if not current_cloud:
			current_cloud = platform
		elif current_cloud != platform:
			current_cloud.fade()
			current_cloud = platform

		# means current cloud faded while standing on it?
		if current_cloud == null:
			_is_on_ground = false

	elif current_cloud != null:
		current_cloud.fade()
		current_cloud = null

	var hor_input = Input.get_axis("left", "right")
	var max_speed: float = move_speed * move_speed_factor

	if not is_zero_approx(hor_input):
		animated_sprite.flip_h = hor_input > 0

	if not _is_on_ground:
		var final_gravity: float = gravity
		if dive_control > 0 and Input.is_action_pressed("down"):
			final_gravity *= 1 + dive_control

		velocity.y += final_gravity * delta

		var wind_force: Vector2 = game.get_force_at(position) * wind_impact

		velocity += wind_force

		var new_velocity_x: float = (
			velocity.x + hor_input * (air_control + air_control_bonus) * delta
		)

		if abs(new_velocity_x) < max_speed or sign(hor_input) != sign(velocity.x):
			velocity.x = new_velocity_x
	else:
		if velocity.y > 0:
			velocity.y = 0

		velocity.x = move_toward(
			velocity.x, hor_input * max_speed, acceleration * move_speed_factor * delta
		)

	jump_logic()

	animation_and_audio_logic()

	move_and_slide()


func jump_logic():
	if (_is_on_ground and velocity.y >= 0) or current_jump_speed > 0:
		if Input.is_action_pressed("up") and current_jump_speed < max_jump_speed + jump_speed_bonus:
			velocity.y -= jump_speed_per_frame
			current_jump_speed += jump_speed_per_frame
			if animated_sprite.animation != "jumping" and animated_sprite.animation == "falling":
				animated_sprite.play("jumping")
		else:
			current_jump_speed = 0
	else:
		current_jump_speed = 0


func animation_and_audio_logic():
	var was_running: bool = _is_running
	_is_running = false

	if _is_on_ground:
		if velocity.x:
			_is_running = true

		if _is_running and not was_running:
			run_audio_delay.start()

		if _is_running:
			animated_sprite.play("running")
			if not audio_run.playing and run_audio_delay.is_stopped():
				audio_run.play()
		else:
			animated_sprite.play("standing")
			audio_run.stop()

	else:
		if (
			dive_control > 0
			and Input.is_action_pressed("down")
			and animated_sprite.animation != "diving"
		):
			animated_sprite.play("diving")
		elif animated_sprite.animation == "running" or animated_sprite.animation == "diving":
			animated_sprite.play("falling")
		audio_run.stop()

	audio_run.pitch_scale = clampf(abs(velocity.x) * 0.01, 1, 3)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	left_screen.emit()


func _on_animated_sprite_animation_finished() -> void:
	animated_sprite.play("falling")
