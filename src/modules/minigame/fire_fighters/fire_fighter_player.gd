class_name FireFighterMinigamePlayer
extends CharacterBody2D

signal extinguish_spot(pos: Vector2)

@export var move_speed: float = 100.0
@export var water_speed: float = 300.0

var last_dir: Vector2

@onready var game: FireFightersMinigame = get_parent()
@onready var extinguisher: Node2D = $Extinguisher
@onready var extinguisher_cooldown: Timer = %Cooldown


func _physics_process(_delta: float) -> void:
	var move_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = move_dir * move_speed
	move_and_slide()

	if move_dir:
		last_dir = move_dir

	extinguisher.look_at(position + last_dir)
	extinguish(Input.is_action_pressed("ui_select"))


func extinguish(flag: bool):
	if not flag:
		return

	if not extinguisher_cooldown.is_stopped():
		return

	var dir: Vector2 = extinguisher.global_transform.x
	var spread: float = 0.2
	dir += dir.rotated(PI / 2) * randf_range(-spread, spread)
	dir = dir.normalized()

	game.add_water(position, velocity + dir * water_speed, extinguisher.global_transform.x)

	extinguisher_cooldown.start()
