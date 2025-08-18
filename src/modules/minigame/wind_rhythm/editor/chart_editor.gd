#@tool
extends Control

const NOTE_TYPE = preload("res://modules/minigame/wind_rhythm/chart/note_types.gd").NoteType

@export var chart: Chart
@export var zoom: int = 100.0
var dock: Control

var beats_per_bar: int
var bpm: float
var lane_count: int = 7
var triplets := false
var pan_x: int = 0
var is_dragging := false
var drag_start_mouse: Vector2
var drag_start_pan: float

var selected_bar = 0
var selected_beat = 0
var selected_relative_beat = 0
var selected_lane = 0
var lane_height
var is_playing = false

@onready var current_beat = $CurrentBeat
@onready var default_font = ThemeDB.fallback_font
@onready var default_font_size = ThemeDB.fallback_font_size


func _ready():
	beats_per_bar = chart.notes_in_bar
	bpm = chart.bpm
	lane_height = size.y / lane_count
	grab_focus()


func _process(_delta):
	var beat_time = (get_viewport().get_mouse_position().x - pan_x) / zoom
	selected_bar = snapped(beat_time - 0.5, 1.0)
	var division = beats_per_bar * 3 if triplets else beats_per_bar
	selected_beat = snappedf(beat_time, 1.0 / division)
	selected_lane = (get_viewport().get_mouse_position().y + lane_height / 2) / size.y * lane_count
	selected_lane = int(selected_lane)
	selected_relative_beat = selected_beat - selected_bar
	if selected_relative_beat == 1.0:
		selected_bar += 1
		selected_relative_beat -= 1.0
	current_beat.text = (
		"%s | %s / %s" % [selected_lane, int(selected_bar), selected_relative_beat]
	)
	if is_playing:
		queue_redraw()


func add_note():
	var lane = 0
	match selected_lane:
		1:
			lane = NOTE_TYPE.UP
		2:
			lane = NOTE_TYPE.LEFT
		3:
			lane = NOTE_TYPE.RIGHT
		4:
			lane = NOTE_TYPE.DOWN
		5:
			lane = NOTE_TYPE.SPECIAL1
		6:
			lane = NOTE_TYPE.SPECIAL2
	var notes = chart.lanes[lane]
	var note = notes.find_custom(
		func(it: NoteData):
			return (
				it.bar == selected_bar
				and (it.beat == (selected_beat - floor(selected_beat)) * beats_per_bar)
			)
	)
	if note == -1:
		var new_note = NoteData.new()
		chart.lanes[lane].append(
			new_note.copy(
				{
					"bar": selected_bar,
					"beat": (selected_beat - floor(selected_beat)) * beats_per_bar,
					"type": lane
				}
			)
		)


func remove_note():
	var lane = 0
	match selected_lane:
		1:
			lane = NOTE_TYPE.UP
		2:
			lane = NOTE_TYPE.LEFT
		3:
			lane = NOTE_TYPE.RIGHT
		4:
			lane = NOTE_TYPE.DOWN
		5:
			lane = NOTE_TYPE.SPECIAL1
		6:
			lane = NOTE_TYPE.SPECIAL2
	var notes = chart.lanes[lane]
	var note = notes.find_custom(
		func(it: NoteData):
			return (
				it.bar == selected_bar
				and (it.beat == (selected_beat - floor(selected_beat)) * beats_per_bar)
			)
	)
	if note != -1:
		chart.lanes[lane].remove_at(note)


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				add_note()
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				remove_note()
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_at_mouse(zoom * 1.1, event.position)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_at_mouse(zoom / 1.1, event.position)
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				is_dragging = true
				drag_start_mouse = event.position
				drag_start_pan = pan_x
			else:
				is_dragging = false
	elif event is InputEventMouseMotion and is_dragging:
		var delta_x = event.position.x - drag_start_mouse.x
		pan_x = drag_start_pan + delta_x
		queue_redraw()
	if event is InputEventKey:
		if event.is_action_pressed("secondary_action"):
			triplets = !triplets
			queue_redraw()
		if event.is_action_pressed("primary_action"):
			is_playing = !is_playing
			if is_playing:
				play_preview()
			else:
				%AudioStreamPlayer.stop()
	if event is InputEventMouse:
		queue_redraw()


func play_preview():
	var stream: AudioStreamPlayer = %AudioStreamPlayer
	stream.stream = chart.audio
	stream.play()
	stream.seek(selected_beat * 60.0 / chart.bpm)


func _draw():
	var lane_height = size.y / lane_count
	for i in range(lane_count):
		draw_line(Vector2(0, i * lane_height), Vector2(size.x, i * lane_height), Color.GRAY)

	for i in range(chart.audio.get_length() / 60 * bpm):
		var division = 3 if triplets else 1
		for j in range(0, beats_per_bar * division):
			draw_line(
				Vector2(i * zoom + j * zoom / beats_per_bar / division + pan_x, 0),
				Vector2(i * zoom + j * zoom / beats_per_bar / division + pan_x, size.y),
				Color.DIM_GRAY
			)
			draw_string(
				default_font,
				Vector2(
					i * zoom + j * zoom / beats_per_bar / division + 10 + pan_x, lane_height + 25
				),
				str(j)
			)

		draw_line(Vector2(i * zoom + pan_x, 0), Vector2(i * zoom + pan_x, size.y), Color.WHITE)
		draw_string(default_font, Vector2(i * zoom + 10 + pan_x, lane_height - 10), str(i))

	for lane in chart.lanes:
		for note: NoteData in chart.lanes[lane]:
			var spawn_lane = 0
			if note.type & NOTE_TYPE.UP:
				spawn_lane = 1
			if note.type & NOTE_TYPE.LEFT:
				spawn_lane = 2
			if note.type & NOTE_TYPE.RIGHT:
				spawn_lane = 3
			if note.type & NOTE_TYPE.DOWN:
				spawn_lane = 4
			if note.type & NOTE_TYPE.SPECIAL1:
				spawn_lane = 5
			if note.type & NOTE_TYPE.SPECIAL2:
				spawn_lane = 6
			draw_circle(
				Vector2(
					(note.bar + note.beat / beats_per_bar) * zoom + pan_x, lane_height * spawn_lane
				),
				10,
				Color.AQUA
			)
	draw_circle(
		Vector2(
			selected_bar * zoom + pan_x + selected_relative_beat * zoom, selected_lane * lane_height
		),
		15,
		Color.from_hsv(120, 1, 1, 0.5)
	)

	var preview = %Waveform
	preview.size.y = lane_height - 25
	preview.size.x = chart.audio.get_length() / 60 * bpm * zoom
	preview.position.x = pan_x
	preview.position.y = size.y - preview.size.y

	if is_playing:
		var song_position = (
			%AudioStreamPlayer.get_playback_position()
			+ AudioServer.get_time_since_last_mix()
			- AudioServer.get_output_latency()
		)
		var play_position = (song_position / 60 * bpm) * zoom + pan_x
		draw_line(Vector2(play_position, 0), Vector2(play_position, size.y), Color.RED)


func zoom_at_mouse(new_zoom: float, mouse_pos: Vector2):
	var old_zoom = zoom
	zoom = clamp(new_zoom, 20.0, 500.0)
	var previous_pos = (mouse_pos.x - pan_x) / old_zoom
	pan_x = mouse_pos.x - previous_pos * zoom
	queue_redraw()


func _on_save_chart_pressed():
	chart.calculate_note_times_in_lanes()
	var error: Error = ResourceSaver.save(chart)
