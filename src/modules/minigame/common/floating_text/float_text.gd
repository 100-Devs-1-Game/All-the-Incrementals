extends Node2D

@export var set_font : Font
@export var float_distance := 40.0
@export var float_duration := 0.6

## Displays the value and animates the floating text before freeing itself.
func show_value(value):
	$ValueLabel.text = str(value)
	$ValueLabel.add_theme_font_override("font", set_font) # Likely not needed
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - float_distance, float_duration)
	tween.tween_property(self, "modulate:a", 0.0, float_duration - 0.3)
	tween.tween_callback(Callable(self, "queue_free"))
