extends Node2D

const NOTE = preload("res://modules/minigame/wind_rhythm/note/note.tscn")
const NOTE_TYPE = preload("res://modules/minigame/wind_rhythm/chart/note_types.gd").NoteType
const JUDGMENT = preload("res://modules/minigame/wind_rhythm/chart/judgments.gd").Judgment

@export var scroll_speed = 10
@export var conductor_path: NodePath
@export var judgment_line: NodePath
@export var debug: float = 0

var chart: Chart
var conductor: Conductor


func _ready():
	conductor = get_node(conductor_path)
	chart = conductor.chart
	spawn_notes()


func spawn_notes():
	var judgment_x = get_node(judgment_line).global_position.x
	var speed = 25

	for note in chart.notes:
		var absolute_beat = note.bar * conductor.notes_in_bar + note.beat
		var note_instance = NOTE.instantiate()

		var spawn_x = absolute_beat * speed
		var spawn_y = global_position.y
		if note.type & NOTE_TYPE.UP:
			spawn_y = 25
			note_instance.rotate(0)
		if note.type & NOTE_TYPE.LEFT:
			spawn_y = 50
			note_instance.rotate(-PI / 2)
		if note.type & NOTE_TYPE.RIGHT:
			spawn_y = 75
			note_instance.rotate(PI / 2)
		if note.type & NOTE_TYPE.DOWN:
			spawn_y = 100
			note_instance.rotate(PI)

		note_instance.global_position = Vector2(judgment_x + spawn_x, spawn_y)
		note_instance.speed = speed * 7  # this number appeared to me in a dream

		add_child(note_instance)
