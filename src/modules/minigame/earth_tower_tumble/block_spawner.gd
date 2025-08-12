extends Node2D


var blocks := [
	preload("res://modules/minigame/earth_tower_tumble/blocks/cblock.tscn"),
	preload("res://modules/minigame/earth_tower_tumble/blocks/iblock.tscn"),
	preload("res://modules/minigame/earth_tower_tumble/blocks/lblock.tscn"),
	preload("res://modules/minigame/earth_tower_tumble/blocks/square.tscn"),
	preload("res://modules/minigame/earth_tower_tumble/blocks/tblock.tscn"),
	preload("res://modules/minigame/earth_tower_tumble/blocks/vblock.tscn"),
	preload("res://modules/minigame/earth_tower_tumble/blocks/zblock.tscn")
]

var current_block: PackedScene


func _ready() -> void:
	get_tree().current_scene.connect("game_started", spawn_block)


func spawn_block():
	var choice = blocks.pick_random()
	var block = choice.instantiate()
	block.connect("released", spawn_block)
	add_child(block)
	block.global_position = global_position
