extends Node2D

var start_position: Vector2
var flight_speed: = 1.3
var shoot_delay := 0.3
var can_shoot := true

@export var POTATO: PackedScene

@onready var inst = get_parent().get_parent()
@onready var point = inst.find_child("Path2D").get_child(0)

func _ready():
	start_position = global_position


func _input(event: InputEvent) -> void:
	if !inst.build_mode:
		if event.is_action_pressed("primary_action"):
			_shoot()
	if Input.is_action_just_pressed("down"):
		inst.build_mode = !inst.build_mode
		point.progress_ratio = 0.5


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
		
	if !inst.build_mode:
		if Input.is_action_pressed("left"):
			point.progress_ratio -= flight_speed * delta
		if Input.is_action_pressed("right"):
			point.progress_ratio += flight_speed * delta
