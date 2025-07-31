class_name WindPlatformerMinigamePlayer
extends CharacterBody2D

@export var move_speed: float = 150.0
@export var acceleration: float = 100.0
@export var jump_speed: float = -100.0
@export var air_control: float = 0.25
@export var wind_impact: float = 1.0
@export var gravity: float = 100.0
@export var damping: float = 0.5

@onready var head: Polygon2D = %Head
@onready var hat: Polygon2D = %Hat

@onready var game: WindPlatformerMinigame = get_parent()


func _physics_process(delta: float) -> void:
	velocity *= (1 - damping * delta)

	var is_on_ground: bool = false

	is_on_ground = is_on_floor()
	#hat.visible = not is_on_ground

	var hor_input = Input.get_axis("ui_left", "ui_right")

	if not is_on_ground:
		velocity.y += gravity * delta
		velocity += game.get_force_at(position) * wind_impact

		velocity.x += hor_input * air_control * delta
	else:
		if velocity.y > 0:
			velocity.y = 0

		if Input.is_action_pressed("ui_up") and velocity.y >= 0:
			velocity.y = jump_speed

		velocity.x = move_toward(velocity.x, hor_input * move_speed, acceleration * delta)

	move_and_slide()
