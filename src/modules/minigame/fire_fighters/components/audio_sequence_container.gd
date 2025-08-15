class_name FireFightersMinigameAudioSequenceContainer
extends Node

@export var sequence: FireFightersMinigameAudioSequence

@export var players: Array[AudioStreamPlayer]


func play(index: int = 0):
	assert(not sequence.streams.is_empty())
	var player: AudioStreamPlayer = get_free_player()
	if not player:
		push_warning("No free AudioPlayer")
		return
	prints("Using player", player.name)
	player.stream = sequence.get_stream(index)
	player.play()


func get_free_player() -> AudioStreamPlayer:
	for player in players:
		if not player.playing:
			return player
	return null
