extends Node2D

const NOTE = preload("res://modules/minigame/wind_rhythm/note/note.tscn")
const NOTE_TYPE = preload("res://modules/minigame/wind_rhythm/chart/note_types.gd").NoteType
const JUDGMENT = preload("res://modules/minigame/wind_rhythm/chart/judgments.gd").Judgment

@export var scroll_speed: float = 2
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
	for note in chart.notes:
		var absolute_beat = note.bar * conductor.notes_in_bar + note.beat
		var judgment_x = get_node(judgment_line).global_position.x

		var spawn_x = absolute_beat * scroll_speed * judgment_x / conductor.notes_in_bar
		# commented out due to being unused, as it fails to pass CI:
		#
		# The local variable "spawn_y" is declared but never used in the block.
		# If this is intended, prefix it with an underscore: "_spawn_y".
		#
		# var spawn_y = global_position.y

		# TODO: Remove hardcoded lanes positions
		if note.type & NOTE_TYPE.UP:
			#spawn_y = 25
			spawn_note(spawn_x, 0, 30)
		if note.type & NOTE_TYPE.LEFT:
			#spawn_y = 50
			spawn_note(spawn_x, -PI / 2, 77)
		if note.type & NOTE_TYPE.RIGHT:
			#spawn_y = 75
			spawn_note(spawn_x, PI / 2, 125)
		if note.type & NOTE_TYPE.DOWN:
			#spawn_y = 100
			spawn_note(spawn_x, PI, 175)


# TODO: Use different arrow sprites instead of rotating
func spawn_note(new_x_position: float, new_rotation: float, lane_position: int):
	var judgment_x = get_node(judgment_line).global_position.x
	var note_instance = NOTE.instantiate()
	note_instance.global_position = Vector2(judgment_x + new_x_position, lane_position)
	note_instance.speed = judgment_x / conductor.seconds_per_beat * scroll_speed

	note_instance.rotate(new_rotation)
	add_child(note_instance)
