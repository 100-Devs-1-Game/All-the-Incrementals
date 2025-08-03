class_name FireFightersMinigameItem
extends Resource

@export var name: String
@export var icon: Texture2D

var unlocked: bool = false


func get_spawn_probability() -> float:
	return 1.0
