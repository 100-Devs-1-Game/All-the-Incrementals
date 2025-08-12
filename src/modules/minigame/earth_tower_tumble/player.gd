extends Node2D

@export var POTATO: PackedScene
@export var flight_speed := 1.3
@export var shoot_delay := 0.3

var can_shoot := true
var start_position: Vector2

@onready var inst = get_tree().current_scene
@export var follow: PathFollow2D

func _ready():
	start_position = global_position
	if follow == null:
		var path2d := inst.find_child("Path2D")
		if path2d and path2d.get_child_count() > 0:
			follow = path2d.get_child(0)

func _input(event: InputEvent) -> void:
	if not inst.build_mode and event.is_action_pressed("primary_action"):
		_shoot()

	if Input.is_action_just_pressed("down"):
		inst.build_mode = not inst.build_mode
		if follow:
			follow.progress_ratio = 0.5

func _shoot():
	if not can_shoot or POTATO == null:
		return
	var pew := POTATO.instantiate()
	pew.global_position = global_position
	get_parent().add_child(pew)
	can_shoot = false
	await get_tree().create_timer(shoot_delay).timeout
	can_shoot = true

func _process(delta: float) -> void:
	var t = clamp(flight_speed * delta, 0.0, 1.0)
	if inst.build_mode:
		global_position = global_position.lerp(start_position, t)
	else:
		if follow:
			global_position = global_position.lerp(follow.global_position, t)

	if not inst.build_mode and follow:
		if Input.is_action_pressed("left"):
			follow.progress_ratio = clamp(follow.progress_ratio - flight_speed * delta, 0.0, 1.0)
		if Input.is_action_pressed("right"):
			follow.progress_ratio = clamp(follow.progress_ratio + flight_speed * delta, 0.0, 1.0)
