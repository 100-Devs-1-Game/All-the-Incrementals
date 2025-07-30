class_name FireFightersMinigameFire
extends Node2D

signal died

@export var offset: float = 5.0
@export var frequency: float = 10.0
# TODO retrieve automatically
@export var animation_frames: int = 4

var size: float = 0.0:
	set(s):
		size = s
		if size < 0.0:
			died.emit()
		elif size > 1.5:
			size = 1.5

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var orig_pos: Vector2 = position


func _ready() -> void:
	animated_sprite.frame = get_animation_frame()


func _process(delta: float) -> void:
	if randf() < delta * frequency:
		animated_sprite.frame = max(0, get_animation_frame() - [0, 0, 0, 1].pick_random())
		if not position.is_equal_approx(orig_pos):
			position = orig_pos
		else:
			position += Vector2(randf_range(-offset, offset), randf_range(-offset, offset))


func get_animation_frame() -> int:
	return lerp(0, animation_frames - 1, size)
