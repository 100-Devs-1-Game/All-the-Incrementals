extends Label

signal combo_broken
signal full_combo
signal perfect_play

const JUDGMENT = preload("res://modules/minigame/wind_rhythm/chart/judgments.gd").Judgment

var combo = 0
var all_perfect = true
var max_notes = 0

@onready var conductor: Conductor = %Conductor


func _ready():
	max_notes = conductor.chart.length()


func _on_rhythm_game_note_missed(_note):
	combo = 0
	all_perfect = false
	text = "%s / %s" % [combo, max_notes]


func _on_rhythm_game_note_played(_note: NoteData, judgment: JUDGMENT):
	combo += 1
	text = "%s / %s" % [combo, max_notes]
	if !judgment & JUDGMENT.PERFECT:
		all_perfect = false
	if combo == max_notes:
		if all_perfect:
			print("All perfect!")
			perfect_play.emit()
		else:
			print("Full combo!")
			full_combo.emit()
