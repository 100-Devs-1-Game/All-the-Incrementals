class_name OverworldLocation3D
extends Node3D

@export var character_spawner: CharacterSpawner


func _ready() -> void:
	assert(character_spawner != null)
