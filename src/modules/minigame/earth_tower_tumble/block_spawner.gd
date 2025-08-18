extends Node2D

@export var blocks: Array[PackedScene] = []
@export var game: Node2D

var current_block: PackedScene


func _ready() -> void:
	get_tree().current_scene.connect("game_started", spawn_block)


func spawn_block():
	if game.blocks_remaining > 0:
		game.blocks_remaining -= 1
		var choice = blocks.pick_random()
		var block = choice.instantiate()
		block.connect("released", spawn_block)
		add_child(block)
		block.global_position = global_position
