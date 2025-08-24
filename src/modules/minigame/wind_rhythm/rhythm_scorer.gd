class_name RhythmScorer extends Control

signal combo_broken
signal full_combo
signal perfect_play

const JUDGMENT = preload("res://modules/minigame/wind_rhythm/chart/judgments.gd").Judgment
const NOTE_TYPE = preload("res://modules/minigame/wind_rhythm/chart/note_types.gd").NoteType

@export var combo_multiplier: float = 2
@export var base_note_score: float = 1
@export var active_lanes: Dictionary[NOTE_TYPE, bool] = {
	NOTE_TYPE.UP: true,
	NOTE_TYPE.LEFT: false,
	NOTE_TYPE.RIGHT: false,
	NOTE_TYPE.DOWN: false,
	NOTE_TYPE.SPECIAL1: false,
	NOTE_TYPE.SPECIAL2: false,
}

var combo: int = 0
var longest_combo: int = 0
var all_perfect: bool = true
var max_notes: int = 0
var score: float = 0
var combo_protection_level = 0

@onready var conductor: Conductor = %Conductor


func start():
	for lane in conductor.chart.lanes.keys().filter(func(lane): return active_lanes[lane]):
		max_notes += conductor.chart.lanes[lane].size()


func on_rhythm_game_note_missed(_note):
	if combo_protection_level > 0:
		combo_protection_level -= 1
	else:
		combo = 0
		all_perfect = false
		combo_broken.emit()
	%ComboLabel.text = "%s / %s" % [combo, max_notes]


func on_rhythm_game_note_played(_note: NoteData, judgment: JUDGMENT):
	score_note(judgment)
	count_combo(judgment)


func score_note(judgment: JUDGMENT):
	var new_score: float = base_note_score
	match judgment:
		JUDGMENT.PERFECT:
			new_score *= 2
		JUDGMENT.GREAT:
			new_score *= 1.5
		JUDGMENT.OKAY:
			new_score *= 1
		JUDGMENT.MISS:
			new_score *= 0
	score += new_score
	$ScoreLabel.text = "%s" % score


func count_combo(judgment: JUDGMENT):
	combo += 1
	longest_combo = max(combo, longest_combo)
	%ComboLabel.text = "%s / %s" % [combo, max_notes]
	if !judgment & JUDGMENT.PERFECT:
		all_perfect = false
	if combo == max_notes:
		if all_perfect:
			print("All perfect!")
			perfect_play.emit()
		else:
			print("Full combo!")
			full_combo.emit()


func count_final_score():
	# TODO: balance multiplier
	score += score * longest_combo / max_notes * combo_multiplier
	get_parent().add_score(score)
