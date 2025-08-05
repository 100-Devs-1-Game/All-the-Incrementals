class_name OffscreenDeleterComponent
extends Node2D

# todo instead of removing them, readd to object pool or something
# maybe for simple ones we could teleport them, it's just a bit iffy.
# better to be slow and correct for now

@export var margin := 256


func _physics_process(_delta: float) -> void:
	if get_parent().global_position.x + margin < WTFGlobals.camera.get_left():
		get_parent().queue_free()
