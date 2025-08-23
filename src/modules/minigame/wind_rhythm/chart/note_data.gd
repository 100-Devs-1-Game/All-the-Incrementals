@tool
class_name NoteData extends Resource

const NOTE_TYPE = preload("res://modules/minigame/wind_rhythm/chart/note_types.gd").NoteType

@export var bar: int
@export var beat: float
@export_flags("Up", "Left", "Right", "Down", "Special1", "Special2") var type: int
@export var cached_absolute_beat: float


func copy(overrides := {}):
	var new_note = NoteData.new()
	new_note.type = overrides.get("type", type)
	new_note.bar = overrides.get("bar", bar)
	new_note.beat = overrides.get("beat", beat)
	new_note.cached_absolute_beat = overrides.get("cached_absolute_beat", cached_absolute_beat)
	return new_note


func _to_string():
	var text = ""
	if type & NOTE_TYPE.UP:
		text += "^ "
	else:
		text += "  "
	if type & NOTE_TYPE.LEFT:
		text += "< "
	else:
		text += "  "
	if type & NOTE_TYPE.RIGHT:
		text += "> "
	else:
		text += "  "
	if type & NOTE_TYPE.DOWN:
		text += "v "
	else:
		text += "  "
	if type & NOTE_TYPE.SPECIAL1:
		text += "! "
	else:
		text += "  "
	return "%s - %s/%s (%s)" % [text, beat, bar, cached_absolute_beat]
