class_name NoteData extends Resource

const NOTE_TYPE = preload("res://modules/minigame/wind_rhythm/chart/note_types.gd").NoteType

@export var bar: int
@export var beat: float
@export_flags("Up", "Left", "Right", "Down", "Special1", "Special2") var type: int
@export var cached_absolute_beat: float


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
	return text + str(cached_absolute_beat)
