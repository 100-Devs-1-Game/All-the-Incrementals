class_name FireFightersMinigamePlayer
extends CharacterBody2D

signal extinguish_spot(pos: Vector2)
signal changed_tile(tile: Vector2i)

@export var move_speed: float = 100.0
@export var acceleration: float = 1000.0
@export var water_speed: float = 200.0
@export var water_spread: float = 0.1
@export var tank_size: float = 5.0
@export var arc_factor: float = 0.1

var _last_dir: Vector2
var _current_item: FireFightersMinigameItem
var _current_tile: Vector2i
var _water_used: float

var _move_speed_factor: float = 1.0
var _water_speed_factor: float = 1.0
var _arc_reduction: float = 1.0
var _water_spread_factor: float = 1.0
var _tank_bonus_size: float = 1.0

@onready var game: FireFightersMinigame = get_parent()
@onready var extinguisher: Node2D = $Extinguisher
@onready var extinguisher_cooldown: Timer = %Cooldown
@onready var extinguisher_offset: Node2D = %"Extinguisher Offset"
@onready var oil_dropper: FireFightersMinigameOilDropComponent = $"Oil Dropper"

# helps to keep the extinguisher shooting diagonally after the player has
# stopped moving ( releasing both keys will let the player face in the direction
# of the last release key otherwise - if they aren't released perfectly simultaneous )
@onready var diagonal_cooldown: Timer = $"Diagonal Cooldown"


func _ready() -> void:
	_current_tile = game.get_tile_at(position)


func _physics_process(delta: float) -> void:
	var move_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = velocity.move_toward(
		move_dir * move_speed * _move_speed_factor, acceleration * delta
	)
	move_and_slide()

	if move_dir:
		if is_diagonal(_last_dir) and not is_diagonal(move_dir):
			if diagonal_cooldown.is_stopped():
				_last_dir = move_dir
		else:
			_last_dir = move_dir

		if is_diagonal(move_dir):
			diagonal_cooldown.start()

	extinguisher.look_at(position + _last_dir)
	extinguish(Input.is_action_pressed("primary_action"))

	if Input.is_action_just_pressed("secondary_action"):
		if has_item():
			use_item()

	_update_tile()


func extinguish(flag: bool):
	if not flag:
		return

	if not extinguisher_cooldown.is_stopped():
		return

	if _water_used > tank_size + _tank_bonus_size:
		return

	var dir: Vector2 = extinguisher.global_transform.x
	var spread: float = water_spread * _water_spread_factor
	dir += dir.rotated(PI / 2) * randf_range(-spread, spread)
	dir = dir.normalized()

	game.add_water(
		extinguisher_offset.global_position,
		dir * water_speed * _water_speed_factor,
		velocity,
		arc_factor * _arc_reduction,
		extinguisher.global_transform.x
	)

	_water_used += 0.1

	extinguisher_cooldown.start()


func pick_up_item(type: FireFightersMinigameItem):
	_current_item = type
	_current_item._on_pick_up(self)


func _update_tile():
	var new_tile: Vector2i = game.get_tile_at(position)
	if _current_tile != new_tile:
		_current_tile = new_tile
		changed_tile.emit(_current_tile)


func can_pick_up_item() -> bool:
	return not has_item()


func use_item():
	assert(has_item())
	_current_item._on_use(self)


func unequip_item():
	_current_item = null


func has_item() -> bool:
	return _current_item != null


func is_diagonal(vec: Vector2) -> bool:
	return abs(vec.x) + abs(vec.y) > 1


func get_tile() -> Vector2i:
	return game.get_tile_at(position)
