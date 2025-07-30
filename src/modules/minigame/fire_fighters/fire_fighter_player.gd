class_name FireFighterMinigamePlayer
extends CharacterBody2D

signal extinguish_spot(pos: Vector2)

@export var move_speed: float = 100.0
@export var water_speed: float = 300.0

var last_dir: Vector2

@onready var game: FireFightersMinigame = get_parent()
@onready var extinguisher: Node2D = $Extinguisher
@onready var extinguisher_cooldown: Timer = %Cooldown


func _physics_process(delta: float) -> void:
	var move_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += move_dir * move_speed * delta

	if move_dir:
		last_dir = move_dir

	extinguisher.look_at(position + last_dir)
	extinguish(Input.is_action_pressed("ui_select"))


func extinguish(flag: bool):
	if not flag:
		return

	if not extinguisher_cooldown.is_stopped():
		return

	game.add_water(position, extinguisher.global_transform.x * water_speed)

	extinguisher_cooldown.start()
