class_name OffscreenDeleterComponent
extends Node2D

# todo instead of removing them, readd to object pool or something
# maybe for simple ones we could teleport them, it's just a bit iffy.
# better to be slow and correct for now

@export var margin := 256

var camera: WTFCamera2D


func _ready() -> void:
	camera = get_tree().get_first_node_in_group("wtf_camera")


func _physics_process(_delta: float) -> void:
	var visible_rect := camera.get_visible_rect()
	if get_parent().global_position.x + margin < visible_rect.position.x:
		get_parent().queue_free()
