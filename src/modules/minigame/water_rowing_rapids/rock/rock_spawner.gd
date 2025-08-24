extends Marker2D

const ROCKS: Array[PackedScene] = [
	preload("res://modules/minigame/water_rowing_rapids/rock/rock_01.tscn"),
	preload("res://modules/minigame/water_rowing_rapids/rock/rock_02.tscn")
]


func _ready() -> void:
	add_child(ROCKS.pick_random().instantiate())
