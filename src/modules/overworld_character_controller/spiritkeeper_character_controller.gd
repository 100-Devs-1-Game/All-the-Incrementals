class_name SpiritkeeperCharacterController3D extends CharacterBody3D

const TERMINAL_VELOCITY := 16.0

const IDLE_ANIMATION_NAME := &"01_idle"
const WALK_ANIMATION_NAME := &"02_walk"
const PLAY_SHAKUHACHI_ANIMATION_NAME := &"03_play_shakuhachi"
const MAP_ANIMATION_NAME := &"04_open_map"

@export_category("Setup")
@export var animation_player: AnimationPlayer
@export var skeleton: Skeleton3D
@export var camera: Camera3D

@export_category("Stats")
@export var movement_speed: float = 6.0
@export var movement_stopping_speed: float = 0.1
@export var acceleration: float = 20.0

@export_category("Features")
@export var is_immobile: bool = false

@export_category("Animation")
@export var staff: Node3D
@export var map: Node3D
@export var shakuhachi: Node3D
@export var spring_bone_simulators: Array[SpringBoneSimulator3D]

@export_group("Model Lean")
@export var lean_pivot_node: Node3D
@export var lean_multiplier: float = 0.3
@export var lean_speed: float = 3.0

@export_group("Model Rotation")
@export var model_rotation_pivot_node: Node3D
@export var model_rotation_speed: float = 10.0

var state_machine: NoxCallableStateMachine

var _last_strong_direction: Vector3


#region states
func idle_state_enter() -> void:
	animation_player.play(IDLE_ANIMATION_NAME)


func idle_state() -> void:
	var desired_movement := get_movement_direction(true)

	velocity = Vector3.ZERO

	if not desired_movement.is_equal_approx(Vector3.ZERO):
		state_machine.change_state(move_state)

	move_and_slide()


func move_state_enter() -> void:
	animation_player.play(WALK_ANIMATION_NAME)


func move_state() -> void:
	var delta := get_physics_process_delta_time()
	var desired_movement := get_movement_direction(true)

	velocity = velocity.move_toward(desired_movement * movement_speed, delta * acceleration)

	var velocity_xz := velocity * Vector3(1.0, 0.0, 1.0)
	if (
		is_equal_approx(desired_movement.length(), 0.0)
		and velocity_xz.length() < movement_stopping_speed
	):
		velocity = Vector3.ZERO
		state_machine.change_state(idle_state)

	move_and_slide()


func interact_state_enter():
	animation_player.play(IDLE_ANIMATION_NAME)


func interact_state():
	pass


#endregion


#region
func get_movement_input() -> Vector2:
	if is_immobile:
		return Vector2.ZERO

	return Input.get_vector("left", "right", "up", "down")


func get_movement_direction(use_camera_basis: bool = false) -> Vector3:
	var raw_input := get_movement_input()

	var move_direction := Vector3(raw_input.x, 0.0, raw_input.y)
	if use_camera_basis:
		var forward := camera.global_basis.z
		var right := camera.global_basis.x

		move_direction = forward * raw_input.y + right * raw_input.x
		move_direction.y = 0.0

	return move_direction.normalized()


func _handle_model_lean(delta: float) -> void:
	var tilt := velocity.normalized().cross(Vector3.UP)
	lean_pivot_node.global_rotation = lean_pivot_node.global_rotation.slerp(
		-tilt * lean_multiplier, delta * lean_speed
	)


func _handle_model_orientation(desired_direction: Vector3, delta: float) -> void:
	var rotation_angle := atan2(desired_direction.x, desired_direction.z)

	model_rotation_pivot_node.rotation.y = lerp_angle(
		model_rotation_pivot_node.rotation.y, rotation_angle, delta * model_rotation_speed
	)


#endregion


#region built-ins
func _ready() -> void:
	EventBus.stop_player_interaction.connect(stop_interaction)

	# states
	state_machine = NoxCallableStateMachine.new()

	state_machine.add_state(idle_state, idle_state_enter)
	state_machine.add_state(move_state, move_state_enter)
	state_machine.add_state(interact_state, interact_state_enter)

	state_machine.set_initial_state(idle_state)

	# animation
	map.hide()
	shakuhachi.hide()


func _physics_process(delta: float) -> void:
	var movement_direction := get_movement_direction(true)
	if not movement_direction.is_equal_approx(Vector3.ZERO):
		_last_strong_direction = movement_direction

	state_machine.update()

	var velocity_xz := velocity * Vector3(1.0, 0.0, 1.0)
	if not velocity_xz.is_equal_approx(Vector3.ZERO):
		_handle_model_orientation(velocity_xz, delta)
	_handle_model_lean(delta)


#endregion


func interact_with(_obj: Node3D):
	state_machine.change_state(interact_state)


func stop_interaction():
	state_machine.change_state(idle_state)
