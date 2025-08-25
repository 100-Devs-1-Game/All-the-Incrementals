class_name RhythmGame extends BaseMinigame

signal note_played(note: NoteData, judgment: JUDGMENT)
signal note_missed(note: NoteData)

const JUDGMENT_PATH = "res://modules/minigame/wind_rhythm/chart/judgments.gd"
const NOTE_TYPE = preload("res://modules/minigame/wind_rhythm/chart/note_types.gd").NoteType
const JUDGMENT = preload(JUDGMENT_PATH).Judgment

@export var autoplay: Dictionary[NOTE_TYPE, JUDGMENT] = {
	NOTE_TYPE.UP: JUDGMENT.MISS,
	NOTE_TYPE.LEFT: JUDGMENT.MISS,
	NOTE_TYPE.RIGHT: JUDGMENT.MISS,
	NOTE_TYPE.DOWN: JUDGMENT.MISS,
	NOTE_TYPE.SPECIAL1: JUDGMENT.MISS,
	NOTE_TYPE.SPECIAL2: JUDGMENT.MISS,
}

@export var active_lanes: Dictionary[NOTE_TYPE, bool] = {
	NOTE_TYPE.UP: true,
	NOTE_TYPE.LEFT: false,
	NOTE_TYPE.RIGHT: false,
	NOTE_TYPE.DOWN: false,
	NOTE_TYPE.SPECIAL1: false,
	NOTE_TYPE.SPECIAL2: false,
}

@export var lanes: Dictionary[NOTE_TYPE, Array] = {
	NOTE_TYPE.UP: [],
	NOTE_TYPE.LEFT: [],
	NOTE_TYPE.RIGHT: [],
	NOTE_TYPE.DOWN: [],
	NOTE_TYPE.SPECIAL1: [],
	NOTE_TYPE.SPECIAL2: [],
}

var conductor: Conductor
var chart: Chart
var judgment_label: Label
var judgments = preload(JUDGMENT_PATH).new()
var concentration_bar: ConcentrationBar
var scorer: RhythmScorer

## Upgrade Info
var drain_speed_mult: float = 1.0
var concentration_max_mult: float = 1
var combo_add: float = 0
var combo_protection_level: int = 0
var perfect_play_bonus: float = 0


func _unhandled_input(event):
	if event.is_action_pressed("up"):
		judge_input(NOTE_TYPE.UP)
	if event.is_action_pressed("left"):
		judge_input(NOTE_TYPE.LEFT)
	if event.is_action_pressed("right"):
		judge_input(NOTE_TYPE.RIGHT)
	if event.is_action_pressed("down"):
		judge_input(NOTE_TYPE.DOWN)
	if event.is_action_pressed("primary_action"):
		judge_input(NOTE_TYPE.SPECIAL1)
	if event.is_action_pressed("secondary_action"):
		judge_input(NOTE_TYPE.SPECIAL2)


func _start():
	conductor = %Conductor
	chart = conductor.chart
	judgment_label = %JudgmentLabel
	concentration_bar = $ConcentrationBar
	lanes = chart.lanes.duplicate(true)
	scorer = %Scorer
	%NoteSpawner.start()
	scorer.active_lanes = active_lanes
	scorer.start()
	concentration_bar.concentration_broken.connect(_on_concentration_broken)
	note_played.connect(concentration_bar.on_note_played)
	note_missed.connect(concentration_bar.on_note_missed)

	note_played.connect(scorer.on_rhythm_game_note_played)
	note_missed.connect(scorer.on_rhythm_game_note_missed)

	#conductor.song_finished.connect(_on_concentration_broken)

	for sprite in $BandSpiritGroup.get_children():
		sprite.play("default")

	## Upgrades
	concentration_bar.drain_speed_mult = drain_speed_mult
	concentration_bar.concentration_max_mult = concentration_max_mult
	concentration_bar.perfect_play_bonus = perfect_play_bonus

	scorer.combo_multiplier += combo_add
	scorer.combo_protection_level = combo_protection_level
	_init_spirits()


func _process(_delta):
	_check_for_missed_notes()
	_auto_play()


func _check_for_missed_notes():
	for lane in lanes.keys().filter(func(lane): return active_lanes[lane]):
		var notes = lanes[lane]
		if notes.is_empty():
			continue

		var note: NoteData = notes[0]

		if conductor.song_position - note.cached_absolute_beat > judgments.miss:
			note_missed.emit(note)
			notes.pop_front()
			judgment_label.text = "Miss"
			%Early_Late.text = ""


func _auto_play():
	for lane in lanes.keys():
		if lane and autoplay:
			var notes = lanes[lane]
			if notes.is_empty():
				continue

			var note: NoteData = notes[0]
			var autoplay_threshold = judgments.miss
			# This is offset by one level
			# because we want to play just outside of previous threshold
			if autoplay[lane] & JUDGMENT.PERFECT:
				autoplay_threshold = 0
			if autoplay[lane] & JUDGMENT.GREAT:
				autoplay_threshold = judgments.perfect
			if autoplay[lane] & JUDGMENT.OKAY:
				autoplay_threshold = judgments.great
			if conductor.song_position - note.cached_absolute_beat > autoplay_threshold:
				judge_input(note.type)


func judge_input(note_type: NOTE_TYPE):
	var lane = lanes[note_type]
	if lane == null:
		return
	var note: NoteData = lane.front()
	if note == null:
		judgment_label.text = ""
		%Early_Late.text = ""
		return
	var time = note.cached_absolute_beat - conductor.song_position
	var absolute_time = abs(time)
	if absolute_time <= judgments.perfect:
		judgment_label.text = "Perfect"
		%Early_Late.text = ""
		note_played.emit(note, JUDGMENT.PERFECT)
		lane.pop_front()
	elif absolute_time <= judgments.great:
		judgment_label.text = "Great"
		%Early_Late.text = "Early" if time > 0 else "Late"
		note_played.emit(note, JUDGMENT.GREAT)
		lane.pop_front()
	elif absolute_time <= judgments.okay:
		judgment_label.text = "Okay"
		%Early_Late.text = "Early" if time > 0 else "Late"
		note_played.emit(note, JUDGMENT.OKAY)
		lane.pop_front()


func _on_concentration_broken():
	conductor.stop()
	scorer.count_final_score()
	game_over()


func _init_spirits():
	for spirit in get_tree().get_nodes_in_group("spirits"):
		if spirit.has_method("on_note_played"):
			note_played.connect(spirit.on_note_played)
