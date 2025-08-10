extends Node

const STREAM: AudioStreamInteractive = preload("res://modules/music/stream.tres")

@onready var _music_player: AudioStreamPlayer = $MusicPlayer


func _init() -> void:
	pass


func _ready() -> void:
	EventBus.request_music.connect(_on_music_request_event)


func _on_music_request_event(song: StringName) -> void:
	if not _music_player.has_stream_playback():
		_music_player[&"parameters/switch_to_clip"] = song
		_music_player.play()
	var playback: AudioStreamPlaybackInteractive = _music_player.get_stream_playback()
	print(_music_player.playing)
	print(playback.get_current_clip_index())
	playback.switch_to_clip_by_name(song)
