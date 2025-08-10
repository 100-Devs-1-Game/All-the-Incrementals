extends Node

const STREAM: AudioStreamInteractive = preload("res://modules/music/stream.tres")

@onready var _music_player: AudioStreamPlayer = $MusicPlayer


func _init() -> void:
	pass


func _ready() -> void:
	EventBus.request_music.connect(_on_music_request_event)


func _on_music_request_event(song: StringName) -> void:
	var playback: AudioStreamPlaybackInteractive = _music_player.get_stream_playback()
	if song == STREAM.get_clip_name(playback.get_current_clip_index()):
		return
	playback.switch_to_clip_by_name(song)
