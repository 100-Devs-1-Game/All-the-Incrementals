class_name EarthTowerTumbleMinigame
extends BaseMinigame

const HEART_EMPTY = preload("res://assets/minigames/earth_tower_tumble/heart_empty.png")
const HEART_FULL = preload("res://assets/minigames/earth_tower_tumble/heart_full.png")

var lives: int = 3
var game_score: int = 0
var peices := 18

@onready var block_handler = $BlockSpawner
@onready var fall_zone = $FallZone
@onready var ui = $MinigameUI
@onready var remaining = $MinigameUI/Rem
@onready var life_slots = ui.get_child(0)


func _initialize() -> void:
	data.apply_all_upgrades(self)


func _start():
	block_handler.start()


func life_lost():
	if lives > 1:
		lives -= 1
	else:
		game_over()
	for i in range(life_slots.get_child_count() - 1, -1, -1):
		var obj = life_slots.get_child(i)
		if obj is TextureRect:
			var tex = obj.get_texture()
			if tex == HEART_FULL:
				obj.set_texture(HEART_EMPTY)
				break


func block_dropped():
	if peices != 0:
		peices -= 1
		_update_ui()
	else:
		game_over()


func _update_ui():
	remaining.text = "Blocks Left: " + str(peices)
