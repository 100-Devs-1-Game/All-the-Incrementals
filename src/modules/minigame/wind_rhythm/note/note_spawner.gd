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

var arrow_sprite: Dictionary[NOTE_TYPE, CompressedTexture2D] = {
	NOTE_TYPE.UP: preload("res://assets/minigames/wind_rhythm/notes/markers/up_arrow_white.png"),
	NOTE_TYPE.LEFT:
	preload("res://assets/minigames/wind_rhythm/notes/markers/left_arrow_white.png"),
	NOTE_TYPE.RIGHT:
	preload("res://assets/minigames/wind_rhythm/notes/markers/right_arrow_white.png"),
	NOTE_TYPE.DOWN:
	preload("res://assets/minigames/wind_rhythm/notes/markers/down_arrow_white.png"),
	NOTE_TYPE.SPECIAL1:
	preload("res://assets/minigames/wind_rhythm/notes/markers/primary_icon_white.png"),
	NOTE_TYPE.SPECIAL2:
	preload("res://assets/minigames/wind_rhythm/notes/markers/secondary_icon_white.png"),
}


func _ready():
	conductor = get_node(conductor_path)
	chart = conductor.chart
	manager = get_node(wind_rhythm)
	spawn_markers()
	spawn_notes()


func spawn_notes():
	print("offset: %s" % offset)
	for lane in chart.lanes.keys():
		for note in chart.lanes[lane]:
			var absolute_beat = note.bar * conductor.notes_in_bar + note.beat + offset
			var judgment_x = get_node(judgment_line).global_position.x

			var spawn_x = absolute_beat * scroll_speed * judgment_x / conductor.notes_in_bar

			# TODO: Remove hardcoded lanes positions
			if note.type & NOTE_TYPE.UP:
				spawn_note(spawn_x, 30, note.copy({"type": NOTE_TYPE.UP}))
			if note.type & NOTE_TYPE.LEFT:
				spawn_note(spawn_x, 77, note.copy({"type": NOTE_TYPE.LEFT}))
			if note.type & NOTE_TYPE.RIGHT:
				spawn_note(spawn_x, 125, note.copy({"type": NOTE_TYPE.RIGHT}))
			if note.type & NOTE_TYPE.DOWN:
				spawn_note(spawn_x, 175, note.copy({"type": NOTE_TYPE.DOWN}))
			if note.type & NOTE_TYPE.SPECIAL1:
				spawn_note(spawn_x, 220, note.copy({"type": NOTE_TYPE.SPECIAL1}))
			if note.type & NOTE_TYPE.SPECIAL2:
				spawn_note(spawn_x, 270, note.copy({"type": NOTE_TYPE.SPECIAL2}))


func spawn_note(new_x_position: float, lane_position: int, note: NoteData):
	var judgment_x = get_node(judgment_line).global_position.x
	var note_instance = NOTE.instantiate()
	note_instance.global_position = Vector2(judgment_x + new_x_position, lane_position * 2)
	note_instance.speed = judgment_x / conductor.seconds_per_beat * scroll_speed

	note_instance.note_time = note.cached_absolute_beat
	note_instance.type = note.type
	manager.note_missed.connect(note_instance.on_miss)
	manager.note_played.connect(note_instance.on_hit)
	add_child(note_instance)


func spawn_markers():
	for lane in [
		[30, NOTE_TYPE.UP],
		[77, NOTE_TYPE.LEFT],
		[125, NOTE_TYPE.RIGHT],
		[175, NOTE_TYPE.DOWN],
		[220, NOTE_TYPE.SPECIAL1],
		[270, NOTE_TYPE.SPECIAL2]
	]:
		var judgment_x = get_node(judgment_line).global_position.x
		var marker = Sprite2D.new()
		marker.texture = arrow_sprite[lane[1]]
		marker.position = Vector2(judgment_x, lane[0] * 2)
		marker.scale = Vector2(0.35, 0.35)
		add_child(marker)

		var marker_outline = Sprite2D.new()
		marker_outline.texture = preload(
			"res://assets/minigames/wind_rhythm/notes/arrow_score_background.png"
		)
		marker_outline.position = Vector2(judgment_x, lane[0] * 2)
		marker_outline.scale = Vector2(0.35, 0.35)
		add_child(marker_outline)
