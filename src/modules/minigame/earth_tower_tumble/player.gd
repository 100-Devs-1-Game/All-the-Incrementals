extends Sprite2D

var sway_amplitude := 4.0  # pixels left/right
var sway_speed := 0.3  # cycles per second
var float_amplitude := 8.0  # pixels up/down
var float_speed := 0.2  # cycles per second

var start_position: Vector2


func _ready():
	start_position = global_position


func _process(_delta: float) -> void:
	var time = Time.get_ticks_msec() / 1000.0
	var x_offset = sin(time * sway_speed * TAU) * sway_amplitude
	var y_offset = sin(time * float_speed * TAU) * float_amplitude
	global_position = start_position + Vector2(x_offset, y_offset)
