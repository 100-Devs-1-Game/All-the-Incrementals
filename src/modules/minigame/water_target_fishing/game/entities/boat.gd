class_name WTFBoat
extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var animated_sprite_2d_2: AnimatedSprite2D = %AnimatedSprite2D2


func _ready() -> void:
	while true:
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(self, "animated_sprite_2d_2:position:x", randf_range(-20, 20), 1)
		tween.tween_property(self, "animated_sprite_2d_2:position:y", randf_range(-20, 20), 1)
		tween.play()
		await tween.finished
		tween.kill()
