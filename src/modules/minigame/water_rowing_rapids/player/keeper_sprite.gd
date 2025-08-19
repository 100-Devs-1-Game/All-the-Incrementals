extends AnimatedSprite2D

const INTENT_THRESHOLD: float = 0.1

var forward_intent: float = 0.0
var rowing: bool = false


func _process(_delta: float) -> void:
	if rowing:
		if absf(forward_intent) < INTENT_THRESHOLD:
			return
		speed_scale = forward_intent
	elif animation == &"idle":
		if use_row():
			start_row()


func _on_animation_finished() -> void:
	speed_scale = 1.0
	rowing = false
	if use_row():
		start_row()
		return
	play("idle")


## Returns [code]true[/code] if row anim should be played (based on current intent)
func use_row() -> bool:
	return absf(forward_intent) > INTENT_THRESHOLD


func start_row() -> void:
	rowing = true
	play("row")

	if forward_intent < 0.0:
		frame = 8
