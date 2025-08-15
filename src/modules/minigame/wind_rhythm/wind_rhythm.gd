extends BaseMinigame


func _start():
	$RhythmGame/ConcentrationBar.connect("concentration_broken", game_over)
