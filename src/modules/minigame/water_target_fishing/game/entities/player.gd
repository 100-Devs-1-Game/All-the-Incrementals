class_name WTFPlayer
extends Node2D

const BROKEN_OXYGEN_SOUND := preload(
	"res://assets/minigames/fire_fighters/sfx/sfx_barrel_break_01.ogg"
)

const BREAKING_OXYGEN_SOUND := preload(
	"res://assets/minigames/fire_fighters/sfx/sfx_metal_impact_04.ogg"
)

const PICKUP_SOUND := preload("res://assets/minigames/fire_fighters/sfx/sfx_oil_splash_05.ogg")

@export var max_speed: float = 400.0
@export var acceleration: float = 2000.0
@export var friction: float = 600.0

var velocity: Vector2 = Vector2.ZERO
var disabled_input := false

@onready var area2d: Area2D = %Area2D
@onready var sprite2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var bubble_shield: AnimatedSprite2D = %BubbleShield
@onready var bubbles: AnimatedSprite2D = %Bubbles


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
	sprite2d.play("default")
	bubble_shield.frame = 6


func _on_area_entered(other_area: Area2D) -> void:
	if !is_instance_valid(other_area):
		push_error(get_path())
		return

	var maybe_fish := other_area.get_parent() as WTFFish
	if is_instance_valid(maybe_fish) && WTFGlobals.minigame.stats.try_carry():
		WTFGlobals.minigame.play_audio(PICKUP_SOUND)
		WTFGlobals.minigame.add_score(maybe_fish.data.pickup.score)
		var ft := TextFloatSystem.floating_text(
			maybe_fish.global_position + Vector2(randf_range(-200, -170), randf_range(-30, 30)),
			"+%d" % maybe_fish.data.pickup.score,
			WTFGlobals.minigame
		)

		ft.set_font_size(floori(48 / WTFGlobals.camera.zoom.x))

		WTFGlobals.minigame.stats.weight += maybe_fish.data.pickup.weight
		WTFGlobals.minigame.stats.scroll_faster(maybe_fish.data.pickup.speedboost)
		maybe_fish.queue_free()
		return

	var maybe_cannon := other_area.get_parent() as WTFJetCannon
	if is_instance_valid(maybe_cannon):
		WTFGlobals.minigame.play_audio(PICKUP_SOUND)
		WTFGlobals.minigame.stats.scroll_faster(maybe_cannon.pickup.speedboost)
		other_area.queue_free()
		return

	var maybe_boat := other_area.get_parent() as WTFBoat
	if is_instance_valid(maybe_boat):
		WTFGlobals.minigame.play_audio(PICKUP_SOUND)
		#todo replace with nice tween of fish leaving etc.
		WTFGlobals.minigame.stats.scroll_faster(500)
		WTFGlobals.minigame.stats.carrying = 0
		WTFGlobals.minigame.stats.weight = 0
		other_area.queue_free()
		return


func _process(_delta: float) -> void:
	if WTFGlobals.minigame.stats.oxygen_percentage() > 80:
		if bubble_shield.frame == 6:
			WTFGlobals.minigame.play_audio(BREAKING_OXYGEN_SOUND)
		bubble_shield.frame = 1
	elif WTFGlobals.minigame.stats.oxygen_percentage() > 60:
		if bubble_shield.frame < 2:
			WTFGlobals.minigame.play_audio(BREAKING_OXYGEN_SOUND)
		bubble_shield.frame = 2
	elif WTFGlobals.minigame.stats.oxygen_percentage() > 40:
		if bubble_shield.frame < 3:
			WTFGlobals.minigame.play_audio(BREAKING_OXYGEN_SOUND)
		bubble_shield.frame = 3
	elif WTFGlobals.minigame.stats.oxygen_percentage() > 20:
		if bubble_shield.frame < 4:
			WTFGlobals.minigame.play_audio(BREAKING_OXYGEN_SOUND)
		bubble_shield.frame = 4
	elif WTFGlobals.minigame.stats.oxygen_percentage() > 0:
		if bubble_shield.frame < 5:
			WTFGlobals.minigame.play_audio(BREAKING_OXYGEN_SOUND)
		bubble_shield.frame = 5
	else:
		if bubble_shield.frame != 6:
			WTFGlobals.minigame.play_audio(BROKEN_OXYGEN_SOUND)
		bubble_shield.frame = 6

	if underwater() && WTFGlobals.minigame.stats.oxygen_percentage() > 0:
		bubbles.play()
	else:
		bubbles.stop()


func _physics_process(delta: float) -> void:
	var input_dir := get_input_direction()
	if disabled_input:
		input_dir = Vector2.ZERO

	if position.y < 0:
		input_dir.y = 0

	input_dir.y *= 3

	if !WTFGlobals.minigame.stats.scrolling():
		WTFGlobals.minigame.stats.consume_oxygen(delta * 10)

	if input_dir != Vector2.ZERO && underwater():
		velocity = velocity.move_toward(
			input_dir * max(velocity.length(), max_speed), acceleration * delta
		)

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

	if underwater():
		WTFGlobals.minigame.stats.consume_oxygen(delta)
		#print("underwater, oxy ", oxygen_remaining_seconds)

		if WTFGlobals.minigame.stats.no_oxygen():
			disabled_input = true

		if WTFGlobals.minigame.stats.no_oxygen() || disabled_input:
			velocity.y += -1 * acceleration * delta

	else:
		if !WTFGlobals.minigame.stats.scrolling():
			disabled_input = true
			print("NO OXYGEN AND NO SPEED")
		elif WTFGlobals.minigame.stats.scrolling() && disabled_input == false:
			WTFGlobals.minigame.stats.refill_oxygen(delta)

		velocity.y += 1 * acceleration * delta

	position += velocity * delta

	# don't let them fall behind out of view
	var min_x := (
		WTFGlobals.camera.get_left()
		+ sprite2d.sprite_frames.get_frame_texture(sprite2d.animation, sprite2d.frame).get_width()
		+ 16
	)

	if position.x < min_x:
		position.x = min_x


func get_input_direction() -> Vector2:
	var dir := Vector2.ZERO

	dir.x += int(Input.is_action_pressed("right"))
	dir.x -= int(Input.is_action_pressed("left"))
	dir.y += int(Input.is_action_pressed("down"))
	dir.y -= int(Input.is_action_pressed("up"))

	return dir.normalized()
