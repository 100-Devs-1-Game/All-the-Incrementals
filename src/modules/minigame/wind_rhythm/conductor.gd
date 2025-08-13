class_name Conductor extends AudioStreamPlayer

signal beat(position)
signal bar(position)

@export var chart: Chart

var song_position: float = 0
var beat_number: int = 0
var song_position_in_beats: int = 0
var seconds_per_beat
var start_offset_in_beats: int = 0
var notes_in_bar: int = 4
var last_beat: int = 0
var current_bar: int = 0


func _ready():
	stream = chart.audio
	play()
	seconds_per_beat = 60.0 / chart.audio.bpm
	notes_in_bar = chart.notes_in_bar


func _process(_delta):
	song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
	# Compensate for output latency.
	song_position -= AudioServer.get_output_latency()
	song_position_in_beats = int(floor(song_position / seconds_per_beat)) + start_offset_in_beats
	_report_beat()


func _report_beat():
	if last_beat < song_position_in_beats:
		if beat_number > notes_in_bar:
			beat_number = 1
		last_beat = song_position_in_beats
		beat.emit(song_position_in_beats)
		beat_number += 1
		current_bar = song_position_in_beats
		bar.emit(current_bar)
		# TODO: cleanup naming of variables, they are not consistent
