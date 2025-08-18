extends Marker2D

const ROCKS: Array[PackedScene] = [preload("uid://xxxxx"), preload("uid://r7ojntqy67it")]


func _ready() -> void:
	add_child(ROCKS.pick_random().instantiate())
