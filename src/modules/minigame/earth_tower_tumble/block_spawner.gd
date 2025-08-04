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
var next_block: PackedScene

func start():
	current_block = blocks.pick_random()
	next_block = blocks.pick_random()
	print(current_block)
	spawn_block(current_block)

func spawn_block(object):
	var block = object.instantiate()
	block.connect("released", spawn_next_block)
	add_child(block)
	block.global_position = global_position

func spawn_next_block():
	current_block = next_block
	spawn_block(current_block)
	next_block = blocks.pick_random()
