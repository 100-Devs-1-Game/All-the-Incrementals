extends Node3D

@export var sway_amount: float = 5.0
@export var noise_speed: float = 0.5
var t: float = 0.0
var initial_rotation: Vector3
var noise := FastNoiseLite.new()


func _ready():
	initial_rotation = rotation_degrees
	noise.seed = randi()
	noise.frequency = 0.1  # equivalent to 'period' control


func _process(delta):
	t += delta * noise_speed
	var sway = noise.get_noise_1d(t) * sway_amount
	rotation_degrees = initial_rotation + Vector3(sway, 0, 0)
