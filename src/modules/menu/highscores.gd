class_name HighScores
extends Control

var minigame: BaseMinigame


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	$ScoresPanel/Scores.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	$ScoresPanel/Scores.size_flags_vertical = Control.SIZE_EXPAND_FILL


func open_menu(highscores: Array[int]) -> void:
	var reversed = highscores.duplicate()
	reversed.reverse()
	for n in $ScoresPanel/Scores.get_children():
		$ScoresPanel/Scores.remove_child(n)
		n.queue_free()
	for i in range(Player.MAX_HIGH_SCORES_STORED):
		var text_label = Label.new()
		text_label.add_theme_font_size_override("font_size", 36)
		text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		if i < reversed.size():
			text_label.text = str(reversed[i])
		else:
			text_label.text = "-"
		$ScoresPanel/Scores.add_child(text_label)
	visible = true


func _on_back_pressed() -> void:
	visible = false
	minigame.open_main_menu()
