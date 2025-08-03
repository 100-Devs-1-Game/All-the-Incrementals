class_name WTFPlayer
extends Node2D

@export var max_speed: float = 400.0
@export var acceleration: float = 2000.0
@export var friction: float = 600.0

var velocity: Vector2 = Vector2.ZERO
var disabled_input := false

@onready var area2d: Area2D = %Area2D
@onready var sprite2d: Sprite2D = %Sprite2D


func underwater() -> bool:
	return position.y >= WTFConstants.SEALEVEL


func _enter_tree() -> void:
	WTFGlobals.player = self
	process_priority = 666666
	process_physics_priority = 66666


func _exit_tree() -> void:
	WTFGlobals.player = null


func _ready() -> void:
	area2d.area_entered.connect(_on_area_entered)


func _on_area_entered(other_area: Area2D) -> void:
	if !is_instance_valid(other_area):
		push_error(get_path())
		return

	var maybe_fish := other_area.get_parent() as WTFFish
	if is_instance_valid(maybe_fish):
		WTFGlobals.minigame.score += maybe_fish.data.pickup.score
		TextFloatSystem.floating_text(
			maybe_fish.global_position, "+%d" % maybe_fish.data.pickup.score, WTFGlobals.minigame
		)

		WTFGlobals.minigame.stats.weight += maybe_fish.data.pickup.weight
		WTFGlobals.minigame.stats.scroll_faster(maybe_fish.data.pickup.pixels_per_second)
		maybe_fish.queue_free()
		return

	var maybe_cannon = other_area.get_parent() as WTFJetCannon
	if is_instance_valid(maybe_cannon):
		WTFGlobals.minigame.score += maybe_cannon.pickup.score
		TextFloatSystem.floating_text(
			maybe_cannon.global_position, "+%d" % maybe_cannon.pickup.score, WTFGlobals.minigame
		)

		WTFGlobals.minigame.stats.weight += maybe_cannon.pickup.weight
		WTFGlobals.minigame.stats.scroll_faster(maybe_cannon.pickup.pixels_per_second)
		return


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
	velocity.x = max(WTFGlobals.minigame.stats.scrollspeed.x / 2, velocity.x)

	# let the player move a tiny bit to the right when we slow down
	# but otherwise, cap it
	if velocity.x > -WTFGlobals.minigame.stats.scrollspeed.x:
		velocity.x = -WTFGlobals.minigame.stats.scrollspeed.x

	#todo this is a bit of a mess... need to clean it up
	# also not sure if/how the disabled input thing should work during gameplay
	# basically trying to force the end to run because of a fail state (no oxy)
	# but giving them time to collect some final points etc. and let their speed drop
	if underwater():
		WTFGlobals.minigame.stats.consume_oxygen(delta)
		#print("underwater, oxy ", oxygen_remaining_seconds)

		if WTFGlobals.minigame.stats.no_oxygen():
			disabled_input = true

		if WTFGlobals.minigame.stats.no_oxygen() || disabled_input:
			velocity.y += -0.4 * acceleration * delta
	else:
		if !WTFGlobals.minigame.stats.scrolling():
			disabled_input = true
			print("NO OXYGEN AND NO SPEED")
		elif disabled_input == false:
			WTFGlobals.minigame.stats.refill_oxygen(delta)

		#todo this magic 0.4 really needs to be tweaked a lot, it feels so strange
		velocity.y += 0.4 * acceleration * delta

	position += velocity * delta

	# don't let them fall behind out of view
	var min_x := WTFGlobals.camera.get_left() + sprite2d.texture.get_width() + 16
	if position.x < min_x:
		position.x = min_x


func get_input_direction() -> Vector2:
	var dir := Vector2.ZERO

	dir.x += int(Input.is_action_pressed("right"))
	dir.x -= int(Input.is_action_pressed("left"))
	dir.y += int(Input.is_action_pressed("down"))
	dir.y -= int(Input.is_action_pressed("up"))

	return dir.normalized()
