extends Node2D

const JUDGMENT = preload("res://modules/minigame/wind_rhythm/chart/judgments.gd").Judgment

@export var speed = 500
var note_time: float = 0
var type: int


func _process(delta):
	position.x -= delta * speed


func on_miss(note: NoteData):
	if note.type == type:
		if note_time == note.cached_absolute_beat:
			%Background.self_modulate = Color(1, 0, 0)


func on_hit(note: NoteData, judgment: JUDGMENT):
	if note.type == type:
		if note_time == note.cached_absolute_beat:
			if judgment & JUDGMENT.PERFECT:
				%Background.self_modulate = Color(0, 1, 0)
			if judgment & JUDGMENT.GREAT:
				%Background.self_modulate = Color(0.5, 1, 0)
			if judgment & JUDGMENT.OKAY:
				%Background.self_modulate = Color(1, 1, 0)
