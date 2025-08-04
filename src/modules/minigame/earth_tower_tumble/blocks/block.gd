extends RigidBody2D

const CELL_SIZE := 32
var target_x: float
var move_speed := 30.0
var is_held := true

var last_delay = false
var touch_delay := 0.2

signal released


func _ready():
	contact_monitor = true
	lock_rotation = true
	continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
	max_contacts_reported = 1
	linear_damp = 3.0
	angular_damp = 5.0
	mass = 10.0
	gravity_scale = 0.5  # Slow preview fall
	target_x = global_position.x
	_randomize_color()


func _randomize_color():
	$Polygon2D.color = Color(randf(), randf(), randf())


func _physics_process(delta):
	if is_held or last_delay:
		if Input.is_action_just_pressed("secondary_action"):
			global_rotation_degrees += 90.0
		if Input.is_action_just_pressed("left"):
			target_x -= CELL_SIZE
		elif Input.is_action_just_pressed("right"):
			target_x += CELL_SIZE
		if Input.is_action_just_pressed("primary_action"):
			_drop_block()

		#linear_velocity += Vector2(0, 3.5)
		global_position.x = lerp(global_position.x, target_x, move_speed * delta)
	if !is_held:
		lock_rotation = false


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if is_held:
		var count = state.get_contact_count()
		for i in count:
			var collider = state.get_contact_collider_object(i)
			if collider and collider is PhysicsBody2D:
				if linear_velocity.length() < 50.0:
					is_held = false
					await get_tree().create_timer(touch_delay).timeout
					_drop_block()
					print("Drop has been block")
					break
	if !is_held:
		var count = state.get_contact_count()
		for i in count:
			var collider = state.get_contact_collider_object(i)
			if collider and collider is RigidBody2D:
				if "is_held" in collider and collider.is_held:
					sleeping = true
					linear_velocity = Vector2.ZERO
					angular_velocity = 0
					break


func _drop_block():
	is_held = false
	gravity_scale = 1.0
	await get_tree().create_timer(0.5).timeout
	released.emit()
