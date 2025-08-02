class_name WTFPlayer
extends Node2D

@export var max_speed: float = 400.0
@export var acceleration: float = 2000.0
@export var friction: float = 600.0

var oxygen_capacity_seconds: float = 3
var oxygen_remaining_seconds: float = oxygen_capacity_seconds
var minigame: WTFMinigame
var camera: WTFCamera2D
var velocity: Vector2 = Vector2.ZERO
var disabled_input := false

@onready var area2d: Area2D = %Area2D
@onready var sprite2d: Sprite2D = %Sprite2D


func _ready() -> void:
	minigame = get_tree().get_first_node_in_group("minigame_water_target_fishing")
	assert(minigame)

	camera = get_tree().get_first_node_in_group("wtf_camera")
	assert(camera)

	area2d.area_entered.connect(_on_area_entered)


func _on_area_entered(other_area: Area2D) -> void:
	if !is_instance_valid(other_area):
		print("!")
		return

	var maybe_fish := other_area.get_parent().get_parent() as WTFFish
	if is_instance_valid(maybe_fish):
		minigame.score += 10
		minigame.current_velocity += Vector2(-300, 0)
		print(minigame.score)
		maybe_fish.queue_free()
		return

	var maybe_cannon = other_area.get_parent() as WTFJetCannon
	if is_instance_valid(maybe_cannon):
		minigame.current_velocity += Vector2(-900, 0)


func _physics_process(delta: float) -> void:
	var input_dir := get_input_direction()
	if disabled_input:
		input_dir = Vector2.ZERO

	if position.y < 0:
		input_dir.y = 0

	# I can't find a nice way to do the movement I want.. ugh, idk anymore
	# how should player movement work independently of the endless scrolling?
	# I wanted something that was more heavy on physics, less on arcade
	# like the player should be able to adjust where their velocity is going (verticality)
	# and use it to aim for fish they can see
	# potentially having stuff to do in the sky as well, if they exit the ocean at velocity
	#rotation += 10 * input_dir.y * delta
	#rotation = rotate_toward(rotation, deg_to_rad(45) * input_dir.y, delta)

	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(input_dir * max_speed, acceleration * delta)

	#todo I was gonna have the player slowly "snap" back to the center based on their distance
	# so there's some freedom, but not too much
	# but idk what I wanna do for the movement right now
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	# this stops the player from moving backwards too much when we slow down
	velocity.x = max(minigame.current_velocity.x / 2, velocity.x)

	# let the player move a tiny bit to the right when we slow down
	# but otherwise, cap it
	if velocity.x > -minigame.current_velocity.x:
		velocity.x = -minigame.current_velocity.x

	#todo this is a bit of a mess... need to clean it up
	# also not sure if/how the disabled input thing should work during gameplay
	# basically trying to force the end to run because of a fail state (no oxy)
	# but giving them time to collect some final points etc. and let their speed drop
	if position.y > 0:
		oxygen_remaining_seconds -= delta
		#print("underwater, oxy ", oxygen_remaining_seconds)

		if oxygen_remaining_seconds <= 0:
			disabled_input = true

		if oxygen_remaining_seconds <= 0 || disabled_input:
			velocity.y += -0.4 * acceleration * delta
	else:
		if minigame.current_velocity.x >= 0:
			disabled_input = true
			print("NO OXYGEN AND NO SPEED")
		elif disabled_input == false:
			print(minigame.current_velocity.x)
			oxygen_remaining_seconds += oxygen_capacity_seconds * delta
			oxygen_remaining_seconds = min(oxygen_remaining_seconds, oxygen_capacity_seconds)
			#print("sky, oxy ", oxygen_remaining_seconds)

		#todo this magic 0.4 really needs to be tweaked a lot, it feels so strange
		velocity.y += 0.4 * acceleration * delta

	position += velocity * delta

	# don't let them fall behind out of view
	if position.x < camera.get_visible_rect().position.x + sprite2d.texture.get_width() + 16:
		position.x = camera.get_visible_rect().position.x + sprite2d.texture.get_width() + 16


func get_input_direction() -> Vector2:
	var dir := Vector2.ZERO

	if Input.is_action_pressed("right"):
		dir.x += 1

	if Input.is_action_pressed("left"):
		dir.x -= 1

	if Input.is_action_pressed("down"):
		dir.y += 1

	if Input.is_action_pressed("up"):
		dir.y -= 1

	return dir.normalized()
