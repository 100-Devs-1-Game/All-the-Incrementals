extends AnimatedSprite2D

const NOTE_TYPE = preload("res://modules/minigame/wind_rhythm/chart/note_types.gd").NoteType

@export var lane: NOTE_TYPE = NOTE_TYPE.UP
@export var animation_divisor: float = 1
@export var restart_on_hit: bool = false

var animation_speed: float

@onready var conductor: Conductor = %Conductor
@onready var notes: Array = conductor.chart.lanes[lane].duplicate()
@onready var total_frames = sprite_frames.get_frame_count("default")


func on_note_played(note: NoteData, _judgment):
	var current_note: NoteData = notes.front()
	if current_note != null and note == current_note:
		current_note = notes.pop_front()
		var next_note: NoteData = notes.front()
		if next_note != null:
			if restart_on_hit:
				frame = 0
			var diff = next_note.cached_absolute_beat - current_note.cached_absolute_beat

			speed_scale = (
				float(total_frames)
				/ diff
				/ sprite_frames.get_animation_speed("default")
				/ animation_divisor
			)
