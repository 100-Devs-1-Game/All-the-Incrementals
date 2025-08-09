extends Sprite2D

var sway_amplitude := 4.0  # pixels left/right
var sway_speed := 0.3  # cycles per second
var float_amplitude := 8.0  # pixels up/down
var float_speed := 0.2  # cycles per second
var start_position: Vector2
var flight_speed: = 15.0
var shoot_delay := 0.3
var can_shoot := true

const POTATO = preload("res://modules/minigame/earth_tower_tumble/potato.tscn")

@onready var inst = get_parent()
@onready var point = inst.find_child("Path2D").get_child(0)

func _ready():
	start_position = global_position


func _input(event: InputEvent) -> void:
	if !inst.build_mode:
		if event.is_action_pressed("primary_action"):
			_shoot()


func _shoot():
	if can_shoot:
		var pew = POTATO.instantiate()
		pew.global_position = global_position
		get_parent().add_child(pew)
		can_shoot = false
		await get_tree().create_timer(shoot_delay).timeout
		can_shoot = true


func _process(delta: float) -> void:
	if inst.build_mode:
		global_position = lerp(global_position, start_position, flight_speed * delta)
	else:
		global_position = lerp(global_position, point.global_position, flight_speed * delta)
