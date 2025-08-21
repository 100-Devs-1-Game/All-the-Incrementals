extends Node2D

const JUDGMENT = preload("res://modules/minigame/wind_rhythm/chart/judgments.gd").Judgment
const NOTE_TYPE = preload("res://modules/minigame/wind_rhythm/chart/note_types.gd").NoteType

@export var speed = 500
var note_time: float = 0
var type: int

var arrow_sprite: Dictionary[NOTE_TYPE, CompressedTexture2D] = {
	NOTE_TYPE.UP: preload("res://assets/minigames/wind_rhythm/notes/up_arrow.png"),
	NOTE_TYPE.LEFT: preload("res://assets/minigames/wind_rhythm/notes/left_arrow.png"),
	NOTE_TYPE.RIGHT: preload("res://assets/minigames/wind_rhythm/notes/right_arrow.png"),
	NOTE_TYPE.DOWN: preload("res://assets/minigames/wind_rhythm/notes/down_arrow.png"),
	NOTE_TYPE.SPECIAL1: preload("res://assets/minigames/wind_rhythm/notes/primary_icon.png"),
	NOTE_TYPE.SPECIAL2: preload("res://assets/minigames/wind_rhythm/notes/secondary_icon.png"),
}

var judgment_sprite: Dictionary[JUDGMENT, CompressedTexture2D] = {
	JUDGMENT.PERFECT: preload("res://assets/minigames/wind_rhythm/notes/perfect_variant.png"),
	JUDGMENT.GREAT: preload("res://assets/minigames/wind_rhythm/notes/great_variant.png"),
	JUDGMENT.OKAY: preload("res://assets/minigames/wind_rhythm/notes/okay_variant.png"),
	JUDGMENT.MISS: preload("res://assets/minigames/wind_rhythm/notes/miss_variant.png"),
}

var marker_sprite: Dictionary[NOTE_TYPE, CompressedTexture2D] = {
	NOTE_TYPE.UP: preload("res://assets/minigames/wind_rhythm/notes/up_note_marker.png"),
	NOTE_TYPE.LEFT: preload("res://assets/minigames/wind_rhythm/notes/left_note_marker.png"),
	NOTE_TYPE.RIGHT: preload("res://assets/minigames/wind_rhythm/notes/right_note_marker.png"),
	NOTE_TYPE.DOWN: preload("res://assets/minigames/wind_rhythm/notes/down_note_marker.png"),
	#NOTE_TYPE.SPECIAL1: preload("res://assets/minigames/wind_rhythm/notes/primary_icon.png"),
	#NOTE_TYPE.SPECIAL2: preload("res://assets/minigames/wind_rhythm/notes/secondary_icon.png"),
}


func _process(delta):
	position.x -= delta * speed


func _ready():
	%Arrow.texture = arrow_sprite[type]
	%ArrowFill.texture = marker_sprite.get(type)


func on_miss(note: NoteData):
	if note.type == type:
		if note_time == note.cached_absolute_beat:
			%Judgment.texture = judgment_sprite[JUDGMENT.MISS]


func on_hit(note: NoteData, judgment: JUDGMENT):
	if note.type == type:
		if note_time == note.cached_absolute_beat:
			%Judgment.texture = judgment_sprite[judgment]
