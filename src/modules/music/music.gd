extends Node

var stream: AudioStreamInteractive

@onready var _music_player: AudioStreamPlayer = $MusicPlayer


func _init() -> void:
	if OS.has_feature("Server"):
		# Trick Unit testing - Don't load the stream.
		# A bug in Godot makes AudioStreamInteractives leak Resources, causing
		# CI/CD to fail.
		return
	stream = load("res://modules/music/stream.tres")


func _ready() -> void:
	_music_player.stream = stream
	EventBus.request_music.connect(_on_music_request_event)
	_music_player.play()


func _on_music_request_event(song: StringName) -> void:
	var playback: AudioStreamPlaybackInteractive = _music_player.get_stream_playback()
	if song == stream.get_clip_name(playback.get_current_clip_index()):
		return
	playback.switch_to_clip_by_name(song)
