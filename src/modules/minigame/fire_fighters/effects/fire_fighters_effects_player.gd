class_name FireFightersMinigameEffectsPlayer
extends Node

@export var water_splash_scene: PackedScene

@onready var game: FireFightersMinigame = get_parent()


func play_water_splash(pos: Vector2):
	assert(game)
	var splash: Node2D = water_splash_scene.instantiate()
	splash.position = pos
	game.effects_node.add_child(splash)
