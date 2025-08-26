class_name Conductor extends AudioStreamPlayer

signal beat(position)
signal bar(position)
signal track_queued(Chart)

const NOTE_TYPE = preload("res://modules/minigame/wind_rhythm/chart/note_types.gd").NoteType

@export var charts: Array[Chart]

var chart: Chart
var song_position: float = 0
var beat_number: int = 0
var song_position_in_beats: int = 0
var seconds_per_beat
var start_offset_in_beats: int = 4
var notes_in_bar: int = 4
var last_beat: int = 0
var current_bar: int = 0
var current_position: float = 0
var chosen_on: int = -1
var playback: AudioStreamPlaybackInteractive


func _ready():
	#chart = charts.pick_random()
	#stream = chart.audio

	stream = AudioStreamInteractive.new()
	stream.clip_count = charts.size()

	for n in charts.size():
		stream.set_clip_name(n, charts[n].name)
		stream.set_clip_stream(n, charts[n].audio)
		print(charts[n].name)
	stream.initial_clip = range(stream.clip_count).pick_random()
	chart = charts[stream.initial_clip]
	stream.add_transition(
		AudioStreamInteractive.CLIP_ANY,
		AudioStreamInteractive.CLIP_ANY,
		AudioStreamInteractive.TRANSITION_FROM_TIME_END,
		AudioStreamInteractive.TRANSITION_TO_TIME_START,
		AudioStreamInteractive.FADE_AUTOMATIC,
		2
	)
	play()
	playback = get_stream_playback()
	seconds_per_beat = 60.0 / chart.audio.bpm
	notes_in_bar = chart.notes_in_bar


func _process(_delta):
	_handle_clip_swap()
	current_position += _delta
	song_position = current_position + AudioServer.get_time_since_last_mix()
	# Compensate for output latency.
	song_position -= AudioServer.get_output_latency()
	song_position_in_beats = int(floor(song_position / seconds_per_beat))


func _handle_clip_swap():
	if chosen_on != playback.get_current_clip_index():
		chosen_on = playback.get_current_clip_index()
		current_position = 0
		print(current_position)
		var manager: RhythmGame = get_parent()
		#manager.lanes = charts[playback.get_current_clip_index()].lanes.duplicate(true)
		var temp := charts[playback.get_current_clip_index()].lanes.duplicate(true)
		for lane in temp.keys():
			temp[lane] = temp[lane].map(
				func(note: NoteData):
					return note.copy(
						{
							"cached_absolute_beat":
							note.cached_absolute_beat + start_offset_in_beats * seconds_per_beat
						}
					)
			)
		manager.lanes = temp
		manager.update_spirits()
		%NoteSpawner.chart = charts[playback.get_current_clip_index()]
		for lane in %NoteSpawner.chart.lanes.keys():
			%NoteSpawner.chart.lanes[lane] = %NoteSpawner.chart.lanes[lane].map(
				func(note: NoteData):
					return note.copy(
						{
							"cached_absolute_beat":
							note.cached_absolute_beat + start_offset_in_beats * seconds_per_beat
						}
					)
			)
		%NoteSpawner.spawn_markers()
		%NoteSpawner.spawn_notes()

		var new_clip = range(stream.clip_count).pick_random()
		while new_clip == playback.get_current_clip_index():
			new_clip = range(stream.clip_count).pick_random()
		print("switching from ", playback.get_current_clip_index(), " to ", new_clip)
		track_queued.emit(charts[new_clip])

		get_stream_playback().switch_to_clip(new_clip)


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
