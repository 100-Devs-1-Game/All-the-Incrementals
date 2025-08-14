class_name FireFightersMinigameAudioSequence
extends Resource

@export var streams: Array[AudioStream]


func get_stream(index: int):
	assert(not streams.is_empty())
	return streams[clampi(index, 0, streams.size())]
