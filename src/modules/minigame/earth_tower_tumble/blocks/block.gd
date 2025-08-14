extends RigidBody2D

signal released
signal placed

const CELL_SIZE := 32
const TOUCH_DELAY := 0.2
const MOVE_SPEED := 45.0
const DROP_GRAVITY := 1.0
const PREVIEW_GRAVITY := 0.5
const SLOW_FALL_GRAVITY := 0.2
const OUT_OF_BOUNDS_Y := 1600.0
const LOW_VELOCITY_THRESHOLD := 50.0

var block_health := 10
var target_x: float
var is_held := true

@onready var inst = get_tree().current_scene
@onready var poly := $Polygon2D


func _ready():
	add_to_group("block")
	_setup_physics()
	target_x = global_position.x
	_randomize_color()


func _physics_process(delta):
	_update_gravity()
	_handle_input(delta)
	_check_out_of_bounds()


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if is_held:
		_check_initial_contact(state)
	else:
		_snap_if_touching_held_block(state)


func _randomize_color():
	poly.color = Color(randf(), randf(), randf())


func _setup_physics():
	contact_monitor = true
	lock_rotation = true
	continuous_cd = CCD_MODE_CAST_SHAPE
	max_contacts_reported = 1
	linear_damp = 3.0
	angular_damp = 5.0
	mass = 10.0
	gravity_scale = PREVIEW_GRAVITY


func _update_gravity():
	if inst.build_mode:
		gravity_scale = PREVIEW_GRAVITY if is_held else DROP_GRAVITY
	else:
		gravity_scale = SLOW_FALL_GRAVITY if is_held else DROP_GRAVITY


func _handle_input(delta):
	if not is_held:
		lock_rotation = false
		return

	if inst.build_mode:
		if Input.is_action_just_pressed("secondary_action"):
			global_rotation_degrees += 90.0
		if Input.is_action_just_pressed("left"):
			target_x -= CELL_SIZE
		elif Input.is_action_just_pressed("right"):
			target_x += CELL_SIZE
		if Input.is_action_just_pressed("primary_action"):
			_drop_block()

	global_position.x = lerp(global_position.x, target_x, MOVE_SPEED * delta)


func _check_out_of_bounds():
	if global_position.y > OUT_OF_BOUNDS_Y:
		inst.block_penalty()
		queue_free()


func _check_initial_contact(state):
	for i in state.get_contact_count():
		var collider = state.get_contact_collider_object(i)
		if collider is PhysicsBody2D and linear_velocity.length() < LOW_VELOCITY_THRESHOLD:
			is_held = false
			await get_tree().create_timer(TOUCH_DELAY).timeout
			_drop_block()
			break


func _snap_if_touching_held_block(state):
	for i in state.get_contact_count():
		var collider = state.get_contact_collider_object(i)
		if collider is RigidBody2D and "is_held" in collider and collider.is_held:
			sleeping = true
			linear_velocity = Vector2.ZERO
			angular_velocity = 0
			break


func damage(amount: int):
	block_health -= amount
	if block_health <= 0:
		queue_free()


func _drop_block():
	is_held = false
	gravity_scale = DROP_GRAVITY
	await get_tree().create_timer(0.5).timeout
	released.emit()
	placed.emit(1)
