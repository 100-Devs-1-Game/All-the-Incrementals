extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(
		$CreditsText, "position", Vector2($CreditsText.position.x, -$CreditsText.size.y), 100
	)
	tween.tween_property($DarkGradient, "modulate", Color(1, 1, 1, 0), 5)
	tween.tween_interval(0.05)
	tween.tween_callback($DarkGradient.queue_free)
	tween.tween_interval(5)
	tween.tween_callback(_done)
	EventBus.emit_signal("ui_credits_start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _done() -> void:
	EventBus.emit_signal("ui_credits_done")


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		print("Credits canceled :(")
		_done()
