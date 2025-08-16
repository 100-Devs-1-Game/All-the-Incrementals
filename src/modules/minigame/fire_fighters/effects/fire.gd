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
		elif size > 2.0:
			size = 2.0

		if size < 0.5 and not audio_player_fire_small.playing:
			audio_player_fire_big.stop()
			audio_player_fire_small.play()
		elif size >= 0.5 and not audio_player_fire_big.playing:
			audio_player_fire_small.stop()
			audio_player_fire_big.play()

var total_burn: float = 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var orig_pos: Vector2 = position

@onready var audio_player_fire_small: AudioStreamPlayer2D = $"AudioStreamPlayer2D Fire Small"
@onready var audio_player_fire_big: AudioStreamPlayer2D = $"AudioStreamPlayer2D Fire Big"


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


func _on_timer_timeout() -> void:
	var frame := animated_sprite.frame
	animated_sprite.animation = "swapped" if animated_sprite.animation == "default" else "default"
	animated_sprite.frame = frame
