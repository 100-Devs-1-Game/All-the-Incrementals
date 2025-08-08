extends Node2D

const JUDGMENT_PATH = "res://modules/minigame/wind_rhythm/chart/judgments.gd"
const NOTE_TYPE = preload("res://modules/minigame/wind_rhythm/chart/note_types.gd").NoteType
const JUDGMENT = preload(JUDGMENT_PATH).Judgment

@onready var conductor: Conductor = %Conductor
@onready var chart: Chart = conductor.chart
@onready var debug_label = %DebugLabel
@onready var judgment_label = %JudgmentLabel

@onready var judgments = preload(JUDGMENT_PATH).new()


func _unhandled_input(event):
	if event.is_action_pressed("up"):
		judge_input(NOTE_TYPE.UP)
	if event.is_action_pressed("left"):
		judge_input(NOTE_TYPE.LEFT)
	if event.is_action_pressed("right"):
		judge_input(NOTE_TYPE.RIGHT)
	if event.is_action_pressed("down"):
		judge_input(NOTE_TYPE.DOWN)


func _process(_delta):
	#var note: NoteData = chart.get_nearest_note(conductor.song_position)
	var note: NoteData = chart.get_nearest_note_by_type(conductor.song_position, NOTE_TYPE.UP)

	if note == null:
		return
	var time = note.cached_absolute_beat - conductor.song_position

	debug_label.text = "%s %s %s" % [conductor.song_position, time, abs(time)]


func judge_input(note_type: NOTE_TYPE):
	var note: NoteData = chart.get_nearest_note_by_type(conductor.song_position, note_type)
	#var note: NoteData = chart.get_nearest_note(conductor.song_position)

	if note == null:
		judgment_label.text = "Miss"
		%Early_Late.text = ""
		return
	var time = note.cached_absolute_beat - conductor.song_position
	var absolute_time = abs(time)
	if absolute_time <= judgments.perfect:
		judgment_label.text = "Perfect"
		%Early_Late.text = ""
	elif absolute_time <= judgments.great:
		judgment_label.text = "Great"
		%Early_Late.text = "Early" if time > 0 else "Late"
	elif absolute_time <= judgments.okay:
		judgment_label.text = "Okay"
		%Early_Late.text = "Early" if time > 0 else "Late"
