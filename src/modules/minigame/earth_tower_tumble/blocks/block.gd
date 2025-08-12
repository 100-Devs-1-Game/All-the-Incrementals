extends RigidBody2D

signal released

var block_health: = 10
var cell_size: = 32
var target_x: float
var move_speed: = 45.0
var is_held: = true

var last_delay = false
var touch_delay := 0.2

@onready var inst = get_tree().current_scene

func _ready():
	add_to_group("block")
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
	if !inst.build_mode and is_held:
		gravity_scale = 0.2
	elif inst.build_mode and is_held:
		gravity_scale = 0.5
	if is_held and inst.build_mode or last_delay:
		if Input.is_action_just_pressed("secondary_action"):
			global_rotation_degrees += 90.0
		if Input.is_action_just_pressed("left"):
			target_x -= cell_size
		elif Input.is_action_just_pressed("right"):
			target_x += cell_size
		if Input.is_action_just_pressed("primary_action"):
			_drop_block()

		global_position.x = lerp(global_position.x, target_x, move_speed * delta)
	if !is_held:
		lock_rotation = false
	
	if global_position.y > 1600.0:
		get_tree().current_scene.block_penalty()
		queue_free()


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


func damage(amount: int):
	block_health -= amount
	if block_health <= 0:
		queue_free()


func _drop_block():
	is_held = false
	gravity_scale = 1.0
	await get_tree().create_timer(0.5).timeout
	released.emit()
