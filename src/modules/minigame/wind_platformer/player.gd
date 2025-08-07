class_name WindPlatformerMinigamePlayer
extends CharacterBody2D

signal left_screen

@export var move_speed: float = 150.0
@export var acceleration: float = 100.0
@export var jump_speed: float = -100.0
@export var air_control: float = 0.25
@export var wind_impact: float = 1.0
@export var gravity: float = 100.0
@export var damping: float = 0.5

var current_cloud: WindPlatformerMinigameCloudPlatform

@onready var head: Polygon2D = %Head
@onready var hat: Polygon2D = %Hat

@onready var game: WindPlatformerMinigame = get_parent()


func _physics_process(delta: float) -> void:
	velocity *= (1 - damping * delta)

	var is_on_ground: bool = false

	is_on_ground = is_on_floor()

	if is_on_ground and not get_last_slide_collision():
		push_warning("On ground without slide collision")

	if is_on_ground and get_last_slide_collision() != null:
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
			is_on_ground = false

	elif current_cloud != null:
		current_cloud.fade()
		current_cloud = null

	var hor_input = Input.get_axis("ui_left", "ui_right")

	if not is_on_ground:
		velocity.y += gravity * delta
		velocity += game.get_force_at(position) * wind_impact

		var new_velocity_x: float = velocity.x + hor_input * air_control * delta

		if new_velocity_x < move_speed or sign(hor_input) != sign(velocity.x):
			velocity.x = new_velocity_x
	else:
		if velocity.y > 0:
			velocity.y = 0

		if Input.is_action_pressed("ui_up") and velocity.y >= 0:
			velocity.y = jump_speed

		velocity.x = move_toward(velocity.x, hor_input * move_speed, acceleration * delta)

	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	left_screen.emit()
