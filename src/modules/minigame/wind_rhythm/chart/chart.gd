@tool
class_name Chart extends Resource

const JUDGMENTS = preload("res://modules/minigame/wind_rhythm/chart/judgments.gd")
const NOTE_TYPE = preload("res://modules/minigame/wind_rhythm/chart/note_types.gd").NoteType

@export var name: String
@export var audio: AudioStream
@export var bpm: int
@export_tool_button("Rebuild notes array", "Reload") var rebuild = rebuild_notes_array_from_lanes
@export var notes_in_bar: int = 4
@export var lanes: Dictionary[NOTE_TYPE, Array] = {
	NOTE_TYPE.UP: [],
	NOTE_TYPE.LEFT: [],
	NOTE_TYPE.RIGHT: [],
	NOTE_TYPE.DOWN: [],
	NOTE_TYPE.SPECIAL1: [],
	NOTE_TYPE.SPECIAL2: [],
}


func length() -> int:
	var size = 0
	for lane in lanes.values():
		size += lane.size()
	return size


func _ready():
	bpm = audio.bpm


func rebuild_notes_array_from_lanes():
	calculate_note_times_in_lanes()

	for lane in lanes.keys():
		lanes[lane].sort_custom(
			func(a: NoteData, b: NoteData): return a.cached_absolute_beat < b.cached_absolute_beat
		)


func calculate_note_times_in_lanes():
	if lanes != null:
		for lane in lanes.keys():
			for note: NoteData in lanes[lane]:
				note.cached_absolute_beat = (
					(note.bar + note.beat / notes_in_bar) * (60.0 / audio.bpm)
				)
