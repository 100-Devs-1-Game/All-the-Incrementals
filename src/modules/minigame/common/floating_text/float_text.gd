class_name FloatingText
extends Node2D

enum AnimationStyle { FLOAT, SCALE, BOUNCE }

@export var set_font: Font
@export var rainbow_text: bool = false  #Never know when yes 😀
@export var float_distance: float = 40.0
@export var float_duration: float = 0.6
@export var animation_style: AnimationStyle = AnimationStyle.FLOAT
@export var font_size: int = 64

var hue: float = 0.0
@onready var valuelbl: Label = $ValueLabel


func _process(delta: float) -> void:
	if rainbow_text:
		hue = fmod(hue + delta, 1.0)
		var color = Color.from_hsv(hue, 1.0, 1.0)
		color.a = modulate.a
		valuelbl.modulate = color


## Displays the value and starts the animation
func show_value(
	value: String,
	style: AnimationStyle = animation_style,
	rainbow: bool = false,
	color: Color = Color.WHITE
) -> void:
	if set_font:
		valuelbl.add_theme_font_override("font", set_font)
	rainbow_text = rainbow
	valuelbl.add_theme_color_override("font_color", color)
	valuelbl.add_theme_font_size_override("font_size", font_size)
	valuelbl.text = str(value)
	animation_style = style
	create_animation(animation_style)


func set_font_size(size: int) -> void:
	valuelbl.add_theme_font_size_override("font_size", size)


func create_animation(anim: AnimationStyle) -> void:
	var tween := create_tween()
	match anim:
		AnimationStyle.FLOAT:
			tween.set_parallel(true)
			tween.tween_property(self, "position:y", position.y - float_distance, float_duration)
			tween.tween_property(self, "modulate:a", 0.0, float_duration - 0.3).set_delay(0.3)
			tween.finished.connect(queue_free)

		AnimationStyle.SCALE:
			scale = Vector2.ZERO
			modulate.a = 1.0
			(
				tween
				. tween_property(self, "scale", Vector2.ONE, float_duration * 0.2)
				. set_trans(Tween.TRANS_BACK)
				. set_ease(Tween.EASE_OUT)
			)
			tween.parallel()
			tween.tween_property(self, "modulate:a", 0.0, float_duration * 0.8)
			tween.tween_property(self, "scale", Vector2.ONE * 0.5, float_duration * 0.8)
			tween.finished.connect(queue_free)
		AnimationStyle.BOUNCE:
			scale = Vector2.ONE
			modulate.a = 1.0
			(
				tween
				. tween_property(self, "scale", Vector2.ONE * 1.3, float_duration * 0.25)
				. set_trans(Tween.TRANS_BACK)
				. set_ease(Tween.EASE_OUT)
			)
			(
				tween
				. tween_property(self, "scale", Vector2.ONE * 0.8, float_duration * 0.2)
				. set_trans(Tween.TRANS_BACK)
				. set_ease(Tween.EASE_IN_OUT)
			)
			(
				tween
				. tween_property(self, "scale", Vector2.ONE, float_duration * 0.15)
				. set_trans(Tween.TRANS_BACK)
				. set_ease(Tween.EASE_OUT)
			)
			tween.parallel()
			tween.tween_property(self, "modulate:a", 0.0, float_duration * 0.4).set_delay(
				float_duration * 0.6
			)
			(
				tween
				. tween_property(
					self, "position:y", position.y - float_distance, float_duration * 0.6
				)
				. set_delay(float_duration * 0.4)
			)
			tween.finished.connect(queue_free)
