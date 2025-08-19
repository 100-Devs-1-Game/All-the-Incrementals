extends Node2D

const NOTE = preload("res://modules/minigame/wind_rhythm/note/note.tscn")
const NOTE_TYPE = preload("res://modules/minigame/wind_rhythm/chart/note_types.gd").NoteType
const JUDGMENT = preload("res://modules/minigame/wind_rhythm/chart/judgments.gd").Judgment

@export var scroll_speed: float = 2
@export var conductor_path: NodePath
@export var judgment_line: NodePath
@export var wind_rhythm: NodePath
@export var offset: float = 0

var chart: Chart
var conductor: Conductor
var manager: RhythmGame


func _ready():
	conductor = get_node(conductor_path)
	chart = conductor.chart
	manager = get_node(wind_rhythm)
	spawn_notes()


func spawn_notes():
	for lane in chart.lanes.keys():
		for note in chart.lanes[lane]:
			var absolute_beat = note.bar * conductor.notes_in_bar + note.beat + offset
			var judgment_x = get_node(judgment_line).global_position.x

			var spawn_x = absolute_beat * scroll_speed * judgment_x / conductor.notes_in_bar

			# TODO: Remove hardcoded lanes positions
			if note.type & NOTE_TYPE.UP:
				spawn_note(spawn_x, 0, 30, note.copy({"type": NOTE_TYPE.UP}))
			if note.type & NOTE_TYPE.LEFT:
				spawn_note(spawn_x, -PI / 2, 77, note.copy({"type": NOTE_TYPE.LEFT}))
			if note.type & NOTE_TYPE.RIGHT:
				spawn_note(spawn_x, PI / 2, 125, note.copy({"type": NOTE_TYPE.RIGHT}))
			if note.type & NOTE_TYPE.DOWN:
				spawn_note(spawn_x, PI, 175, note.copy({"type": NOTE_TYPE.DOWN}))
			if note.type & NOTE_TYPE.SPECIAL1:
				spawn_note(spawn_x, PI / 4, 220, note.copy({"type": NOTE_TYPE.SPECIAL1}))
			if note.type & NOTE_TYPE.SPECIAL2:
				spawn_note(spawn_x, -PI / 4, 270, note.copy({"type": NOTE_TYPE.DOWN}))


# TODO: Use different arrow sprites instead of rotating
func spawn_note(new_x_position: float, new_rotation: float, lane_position: int, note: NoteData):
	var judgment_x = get_node(judgment_line).global_position.x
	var note_instance = NOTE.instantiate()
	note_instance.global_position = Vector2(judgment_x + new_x_position, lane_position)
	note_instance.speed = judgment_x / conductor.seconds_per_beat * scroll_speed

	note_instance.rotate(new_rotation)
	note_instance.note_time = note.cached_absolute_beat
	note_instance.type = note.type
	manager.note_missed.connect(note_instance.on_miss)
	manager.note_played.connect(note_instance.on_hit)
	add_child(note_instance)
