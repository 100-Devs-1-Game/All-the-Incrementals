@tool
class_name Chart extends Resource

const JUDGMENTS = preload("res://modules/minigame/wind_rhythm/chart/judgments.gd")
const NOTE_TYPES = preload("res://modules/minigame/wind_rhythm/chart/note_types.gd").NoteType

@export var name: String
@export var audio: AudioStream
@export var bpm: int
@export_tool_button("Sort Bars", "Sort") var sort = sort_notes
@export_tool_button("Calculate note times", "Time") var calculate = calculate_note_times
@export var notes: Array[NoteData]


func _ready():
	bpm = audio.bpm


func sort_notes():
	notes.sort_custom(func(a: NoteData, b: NoteData): return a.bar < b.bar)


func calculate_note_times():
	if notes != null:
		for note: NoteData in notes:
			note.cached_absolute_beat = (note.bar + note.beat) * (60.0 / audio.bpm)


func get_note_data_from_bar(bar: int) -> NoteData:
	var index = notes.find_custom(func(note: NoteData): return note.bar == bar)
	if index != -1:
		return notes[index]
	return null


func get_nearest_note(time: float) -> NoteData:
	# song time +/- lowest judgment
	var limit = JUDGMENTS.new().okay
	var index = notes.find_custom(
		func(note: NoteData):
			return (
				note.cached_absolute_beat < (time + limit)
				and note.cached_absolute_beat > (time - limit)
			)
	)
	if index != -1:
		print(notes[index])
		return notes[index]
	return null


# Not a fan of this function, maybe we could precalculate and split notes by types?
# Same question for replacing array with dictionary,
# then we could access bar-1, bar, bar+1 (for overlap) directly
# instead of iterating through array each time
# Also we need some way to get notes past their miss window
func get_nearest_note_by_type(time: float, type: NOTE_TYPES) -> NoteData:
	var limit = JUDGMENTS.new().okay
	var filtered_notes = notes.filter(func(note: NoteData): return note.type & type)
	var index = filtered_notes.find_custom(
		func(note: NoteData):
			return (
				note.cached_absolute_beat < (time + limit)
				and note.cached_absolute_beat > (time - limit)
			)
	)
	if index != -1:
		return filtered_notes[index]
	return null
