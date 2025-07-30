class_name FireFighterMinigamePlayer
extends CharacterBody2D

signal extinguish_spot(pos: Vector2)

@export var move_speed: float = 100.0

var last_dir: Vector2

@onready var extinguisher_particles: CPUParticles2D = %CPUParticles2D
@onready var extinguisher: Node2D = $Extinguisher
@onready var extinguisher_target: Node2D = %"Extinguisher Target"


func _physics_process(delta: float) -> void:
	var move_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += move_dir * move_speed * delta

	if move_dir:
		last_dir = move_dir

	extinguisher.look_at(position + last_dir)
	extinguish(Input.is_action_pressed("ui_select"))


func extinguish(flag: bool):
	extinguisher_particles.emitting = flag
	if flag:
		var rnd := Vector2(randf_range(-20, 20), randf_range(-20, 20))
		extinguish_spot.emit(extinguisher_target.global_position + rnd)
