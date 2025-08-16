@tool
class_name Chart extends Resource

const JUDGMENTS = preload("res://modules/minigame/wind_rhythm/chart/judgments.gd")
const NOTE_TYPE = preload("res://modules/minigame/wind_rhythm/chart/note_types.gd").NoteType

@export var name: String
@export var audio: AudioStream
@export var bpm: int
@export_tool_button("Sort Bars", "Sort") var sort = sort_notes
@export_tool_button("Calculate note times", "Time") var calculate = calculate_note_times
@export_tool_button("Rebuild notes array", "Reload") var rebuild = _rebuild_notes_array_from_lanes
@export var notes: Array[NoteData]
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


func _rebuild_notes_array():
	calculate_note_times()
	for lane in lanes.keys():
		lanes[lane].clear()

	for note: NoteData in notes:
		if note.type & NOTE_TYPE.UP:
			lanes[NOTE_TYPE.UP].append(note.copy({"type": NOTE_TYPE.UP}))
		if note.type & NOTE_TYPE.LEFT:
			lanes[NOTE_TYPE.LEFT].append(note.copy({"type": NOTE_TYPE.LEFT}))
		if note.type & NOTE_TYPE.RIGHT:
			lanes[NOTE_TYPE.RIGHT].append(note.copy({"type": NOTE_TYPE.RIGHT}))
		if note.type & NOTE_TYPE.DOWN:
			lanes[NOTE_TYPE.DOWN].append(note.copy({"type": NOTE_TYPE.DOWN}))
		if note.type & NOTE_TYPE.SPECIAL1:
			lanes[NOTE_TYPE.SPECIAL1].append(note.copy({"type": NOTE_TYPE.SPECIAL1}))
		if note.type & NOTE_TYPE.SPECIAL2:
			lanes[NOTE_TYPE.SPECIAL2].append(note.copy({"type": NOTE_TYPE.SPECIAL2}))

	calculate_note_times_in_lanes()

	for lane in lanes.keys():
		lanes[lane].sort_custom(
			func(a: NoteData, b: NoteData): return a.cached_absolute_beat < b.cached_absolute_beat
		)


func _rebuild_notes_array_from_lanes():
	notes.clear()

	for lane in lanes.keys():
		for note: NoteData in lanes[lane]:
			if note.type & NOTE_TYPE.UP:
				notes.append(note.copy({"type": NOTE_TYPE.UP}))
			if note.type & NOTE_TYPE.LEFT:
				notes.append(note.copy({"type": NOTE_TYPE.LEFT}))
			if note.type & NOTE_TYPE.RIGHT:
				notes.append(note.copy({"type": NOTE_TYPE.RIGHT}))
			if note.type & NOTE_TYPE.DOWN:
				notes.append(note.copy({"type": NOTE_TYPE.DOWN}))
			if note.type & NOTE_TYPE.SPECIAL1:
				notes.append(note.copy({"type": NOTE_TYPE.SPECIAL1}))
			if note.type & NOTE_TYPE.SPECIAL2:
				notes.append(note.copy({"type": NOTE_TYPE.SPECIAL2}))

	calculate_note_times_in_lanes()

	for lane in lanes.keys():
		lanes[lane].sort_custom(
			func(a: NoteData, b: NoteData): return a.cached_absolute_beat < b.cached_absolute_beat
		)


func sort_notes():
	notes.sort_custom(func(a: NoteData, b: NoteData): return a.bar < b.bar)


func calculate_note_times():
	if notes != null:
		for note: NoteData in notes:
			note.cached_absolute_beat = (note.bar + note.beat / notes_in_bar) * (60.0 / audio.bpm)


func calculate_note_times_in_lanes():
	if lanes != null:
		for lane in lanes.keys():
			for note: NoteData in lanes[lane]:
				note.cached_absolute_beat = (
					(note.bar + note.beat / notes_in_bar) * (60.0 / audio.bpm)
				)
