class_name FireFightersMinigamePlayer
extends CharacterBody2D

signal extinguish_spot(pos: Vector2)

@export var move_speed: float = 100.0
@export var acceleration: float = 1000.0
@export var water_speed: float = 300.0
@export var arc_factor: float = 0.1

var last_dir: Vector2

@onready var game: FireFightersMinigame = get_parent()
@onready var extinguisher: Node2D = $Extinguisher
@onready var extinguisher_cooldown: Timer = %Cooldown
@onready var extinguisher_offset: Node2D = %"Extinguisher Offset"

# helps to keep the extinguisher shooting diagonally after the player has
# stopped moving ( releasing both keys will let the player face in the direction
# of the last release key otherwise - if they aren't released perfectly simultaneous )
@onready var diagonal_cooldown: Timer = $"Diagonal Cooldown"


func _physics_process(delta: float) -> void:
	var move_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = velocity.move_toward(move_dir * move_speed, acceleration * delta)
	move_and_slide()

	if move_dir:
		if is_diagonal(last_dir) and not is_diagonal(move_dir):
			if diagonal_cooldown.is_stopped():
				last_dir = move_dir
		else:
			last_dir = move_dir

		if is_diagonal(move_dir):
			diagonal_cooldown.start()

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

	game.add_water(
		extinguisher_offset.global_position,
		dir * water_speed,
		velocity,
		arc_factor,
		extinguisher.global_transform.x
	)

	extinguisher_cooldown.start()


func pick_up_item(_type: FireFightersMinigameItem):
	pass


func is_diagonal(vec: Vector2) -> bool:
	return abs(vec.x) + abs(vec.y) > 1


func get_tile() -> Vector2i:
	return game.get_tile_at(position)
