extends Node3D

@export var move_speed := 0.5
@export var float_amplitude := 0.5
@export var float_speed := 1.0
@export var direction := Vector3(-1, 0, 0)

var time := 0.0
var original_positions := []


func _ready():
	for cloud in get_children():
		if cloud is Sprite3D:
			original_positions.append(cloud.global_transform.origin)


func _process(delta):
	time += delta
	for i in original_positions.size():
		var cloud = get_child(i)
		if cloud is Sprite3D:
			var float_offset = sin(time * float_speed + i) * float_amplitude
			var base_pos = original_positions[i]
			var cam = get_viewport().get_camera_3d()
			var screen_left = -cam.global_transform.basis.x
			var pos = base_pos + screen_left * move_speed * time
			pos.y += float_offset
			cloud.global_transform.origin = pos
