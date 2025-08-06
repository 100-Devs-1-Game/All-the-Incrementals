class_name FireFightersMinigamePlayer
extends CharacterBody2D

signal extinguish_spot(pos: Vector2)
signal changed_tile(tile: Vector2i)

@export var move_speed: float = 100.0
@export var acceleration: float = 1000.0
@export var water_speed: float = 300.0
@export var arc_factor: float = 0.1

var last_dir: Vector2
var _current_item: FireFightersMinigameItem
var _current_tile: Vector2i

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
