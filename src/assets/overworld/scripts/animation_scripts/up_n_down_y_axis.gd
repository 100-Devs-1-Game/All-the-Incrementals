extends Node3D

@export var float_speed := 1.25  # How fast it bobs
@export var float_amplitude := 0.056  # How high it floats

var base_y := 0.0


func _ready():
	base_y = global_transform.origin.y


@warning_ignore("unused_parameter")
func _process(_delta: float) -> void:
	var new_y = base_y + sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_amplitude
	# You could change this to: sin(OS.get_ticks_msec() * 0.001 * float_speed) too

	var new_transform = global_transform
	new_transform.origin.y = new_y
	global_transform = new_transform
