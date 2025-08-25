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
var enable_dynamic_spring_arm_length: bool = true

var _last_strong_direction: Vector3
var _possible_interaction: InteractionComponent3D
var _interaction_finished_sound: AudioStream
var _current_dialog: NPCDialog
var _dialog_selection_index: int = -1

@onready var label_interaction_hint: Label = %"Label Interaction Hint"
@onready var shapecast_floor_check: ShapeCast3D = %"ShapeCast3D Floor Check"
@onready var raycast_ground_contact: RayCast3D = $"RayCast3D Ground Contact"
@onready var audio_player_interaction: AudioStreamPlayer = $"AudioStreamPlayer Interaction"
@onready var camera_spring_arm: SpringArm3D = $CameraController/CameraPivot/SpringArm3D
@onready var orig_spring_arm_length: float = camera_spring_arm.spring_length
@onready var dialog_parent: MarginContainer = %"MarginContainer Dialog"
@onready var dialog_vbox: VBoxContainer = %"VBoxContainer Dialog"


#region states
func idle_state_enter() -> void:
	animation_player.play(IDLE_ANIMATION_NAME)


func idle_state() -> void:
	var desired_movement := get_movement_direction(true)

	velocity = Vector3.ZERO

	if not desired_movement.is_equal_approx(Vector3.ZERO):
		state_machine.change_state(move_state)

	move()


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

	move()


func interact_state_enter():
	animation_player.play(IDLE_ANIMATION_NAME)


func interact_state():
	if _current_dialog:
		if Input.is_action_just_pressed("primary_action"):
			display_dialog()

		if Input.is_action_just_pressed("exit_menu"):
			end_dialog()

		var choose: int = 0
		if Input.is_action_just_pressed("up"):
			choose = -1
		if Input.is_action_just_pressed("down"):
			choose = 1

		if choose != 0:
			var choices := dialog_vbox.get_child_count()
			if _dialog_selection_index == -1:
				_dialog_selection_index = 0

			_dialog_selection_index = wrapi(_dialog_selection_index + choose, 0, choices)
			display_dialog(false)


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


func move():
	if enable_dynamic_spring_arm_length:
		adjust_spring_arm()

	if shapecast_floor_check.is_colliding():
		move_and_slide()

	if not raycast_ground_contact.is_colliding():
		apply_floor_snap()


func adjust_spring_arm():
	var dot: float = velocity.normalized().dot(global_position.direction_to(camera.global_position))
	var target_length: float = lerp(
		orig_spring_arm_length, orig_spring_arm_length * 2, clampf(dot, 0.0, 1.0)
	)
	camera_spring_arm.spring_length = lerp(
		camera_spring_arm.spring_length, target_length, get_physics_process_delta_time()
	)


#endregion


#region built-ins
func _ready() -> void:
	EventBus.stop_player_interaction.connect(stop_interaction)
	EventBus.notify_player_possible_interaction.connect(_on_possible_interaction)
	EventBus.notify_player_interaction_lost.connect(_on_interaction_lost)

	# states
	state_machine = NoxCallableStateMachine.new()

	state_machine.add_state(idle_state, idle_state_enter)
	state_machine.add_state(move_state, move_state_enter)
	state_machine.add_state(interact_state, interact_state_enter)

	state_machine.set_initial_state(idle_state)

	# animation
	map.hide()
	shakuhachi.hide()

	# misc
	shapecast_floor_check.add_exception_rid(get_rid())


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

#region interactions


func interact_with(_obj: Node3D) -> bool:
	label_interaction_hint.hide()
	if state_machine.current_state_equals(interact_state):
		return false
	state_machine.change_state(interact_state)
	return true


func stop_interaction():
	if _interaction_finished_sound:
		audio_player_interaction.stream = _interaction_finished_sound
		audio_player_interaction.play()
	state_machine.change_state(idle_state)


func set_interaction_sounds(initial_sound: AudioStream, finishing_sound: AudioStream):
	if initial_sound:
		audio_player_interaction.stream = initial_sound
		audio_player_interaction.play()
	_interaction_finished_sound = finishing_sound


func _on_possible_interaction(component: InteractionComponent3D):
	_possible_interaction = component
	if component.action_ui_suffix:
		label_interaction_hint.text = "Press SPACE to " + component.action_ui_suffix
		label_interaction_hint.show()


func _on_interaction_lost(component: InteractionComponent3D):
	if component == _possible_interaction:
		label_interaction_hint.hide()


func is_interacting() -> bool:
	return state_machine.current_state_equals(interact_state)


#endregion

#region dialog


func start_dialog(dialog: NPCDialog):
	assert(not _current_dialog)
	_current_dialog = dialog
	if not _current_dialog.state:
		_current_dialog.state = NPCDialogState.new()

	_current_dialog.state.current_index = 0
	_dialog_selection_index = -1

	display_dialog()


func display_dialog(advance: bool = true):
	clear_dialog()
	var lines := _current_dialog.get_next_lines()
	if lines.is_empty():
		end_dialog()
		return

	add_dialog_labels(lines)
	if advance:
		_current_dialog.advance(_dialog_selection_index)
		if _dialog_selection_index > -1:
			_dialog_selection_index = -1

	dialog_parent.show()


func add_dialog_labels(arr: Array[String]):
	for i in arr.size():
		var text := arr[i]

		var label := Label.new()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.custom_minimum_size.x = 1700
		label.add_theme_constant_override("line_spacing", -30)
		label.text = text

		if arr.size() > 1 and i != _dialog_selection_index:
			label.modulate = Color.DIM_GRAY

		dialog_vbox.add_child(label)


func end_dialog():
	clear_dialog()
	dialog_parent.hide()
	_current_dialog = null
	state_machine.change_state(idle_state)


func clear_dialog():
	for child in dialog_vbox.get_children():
		dialog_vbox.remove_child(child)
		child.queue_free()

#endregion
