extends AnimatedSprite2D


func _on_wind_rhythm_note_missed(_note):
	play("miss")


func _on_wind_rhythm_note_played(_note, _judgment):
	# We want miss animation to be visible even when playing good notes shortly after
	if animation == "miss" and !is_playing():
		play("default")
