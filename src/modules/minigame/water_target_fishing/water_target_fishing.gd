class_name WTFMinigame
extends BaseMinigame

const SECONDS_BEFORE_ENDING_RUN: float = 1
const SPAWN_FISH_EVERY_X_PIXELS_TRAVELLED: float = 300
const SPAWN_STARTING_FISH: float = 3

@export var fish: PackedScene

var current_velocity: Vector2 = Vector2(-200, 0)
var base_slow: float = 100

var distance_travelled = 0
var distance_travelled_left_to_spawn = SPAWN_FISH_EVERY_X_PIXELS_TRAVELLED * SPAWN_STARTING_FISH
var score_weight_modifier = 3

var _pixels_per_second: float = 0

@onready var fish_db: WTFFishDB = %WTFFishDB


func get_pixels_per_second() -> int:
	return floor(_pixels_per_second)


func _enter_tree() -> void:
	WTFGlobals.minigame = self

	## yyyy does it stutter thoooo
	# I can't find any magic number that solves it :(
	process_priority = 55555
	process_physics_priority = 55555


func _exit_tree() -> void:
	WTFGlobals.minigame = null


func _process(_delta: float) -> void:
	(%UISpeedValue as RichTextLabel).text = str(get_pixels_per_second())
	(%UIScoreValue as RichTextLabel).text = str(score)
	(%UIOxygenValue as RichTextLabel).text = (
		str(
			floori(
				(
					(
						max(0, WTFGlobals.player.oxygen_remaining_seconds)
						/ WTFGlobals.player.oxygen_capacity_seconds
					)
					* 100.0
				)
			)
		)
		+ "%"
	)
	(%UIWeightValue as RichTextLabel).text = str(
		floori(base_slow + (score * score_weight_modifier))
	)
	(%UIDistanceValue as RichTextLabel).text = str(floori(distance_travelled))


func _spawn_fish() -> void:
	#don't spawn when flying
	if WTFGlobals.camera.get_bottom() <= WTFConstants.SEALEVEL:
		return

	var f: WTFFish = fish.instantiate()
	var rand_offset := randf_range(-current_velocity.x, -current_velocity.x * 4)
	f.position.x = (distance_travelled + WTFGlobals.camera.get_right() + rand_offset)  #avoid clump
	f.position.y = randf_range(min(0, WTFGlobals.camera.get_top()), WTFGlobals.camera.get_bottom())
	f.data = fish_db.random()
	%Entities.add_child(f)


func _physics_process(delta: float) -> void:
	current_velocity.x += (base_slow + (score * score_weight_modifier)) * delta

	# effectively stopped
	if current_velocity.x >= 0:
		current_velocity.x = 0

		#todo end the run and show summary or ui to restart or buy upgrades
		# hack that acts as a one second timer before the run ends
		var player_done := WTFGlobals.player.oxygen_remaining_seconds <= -SECONDS_BEFORE_ENDING_RUN
		if !WTFGlobals.player.underwater() && player_done:
			get_tree().reload_current_scene()

	_pixels_per_second = -current_velocity.x

	distance_travelled += _pixels_per_second * delta
	distance_travelled_left_to_spawn += _pixels_per_second * delta

	#todo replace with good spawning
	while distance_travelled_left_to_spawn > SPAWN_FISH_EVERY_X_PIXELS_TRAVELLED:
		_spawn_fish()
		distance_travelled_left_to_spawn -= SPAWN_FISH_EVERY_X_PIXELS_TRAVELLED
