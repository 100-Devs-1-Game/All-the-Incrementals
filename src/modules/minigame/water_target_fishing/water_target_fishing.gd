class_name WTFMinigame
extends BaseMinigame

const SECONDS_BEFORE_ENDING_RUN: float = 1

@export var fish: PackedScene

var stats: WTFStats

var _distance_travelled := 0.0
var _distance_since_spawned := 0.0

var _started: bool = false
var _old_physics_tickrate: int
var _first_spawn: bool = true

@onready var fish_db: WTFFishDB = %WTFFishDB
@onready var parallax_db: WTFParallaxDB = %WTFParallaxDB

@onready var ui_speed_value: RichTextLabel = %UISpeedValue
@onready var ui_score_value: RichTextLabel = %UIScoreValue
@onready var ui_oxygen_value: RichTextLabel = %UIOxygenValue
@onready var ui_weight_value: RichTextLabel = %UIWeightValue
@onready var ui_distance_value: RichTextLabel = %UIDistanceValue
@onready var ui_carry_value: RichTextLabel = %UICarryValue


func get_pixels_per_second() -> int:
	return floori(-stats.scrollspeed.x)


func _enter_tree() -> void:
	WTFGlobals.minigame = self
	_old_physics_tickrate = Engine.physics_ticks_per_second
	Engine.physics_ticks_per_second = 10

	## yyyy does it stutter thoooo
	# I can't find any magic number that solves it :(
	process_priority = 55555
	process_physics_priority = 55555


func _exit_tree() -> void:
	WTFGlobals.minigame = null
	Engine.physics_ticks_per_second = _old_physics_tickrate


func _initialize() -> void:
	stats = WTFStats.new()


func _start() -> void:
	# to handle some upgrades
	stats.reset()

	# give it an initial amount so we can get some fishies going
	_distance_since_spawned = stats.spawn_fish_every_x_pixels * stats.spawn_x_starting_fish
	print(
		(
			"starting speed %s with %s%% (+%s) speedboost"
			% [
				-stats.scrollspeed_initial.x,
				stats.speedboost_multiplier * 100,
				stats.speedboost_flat
			]
		)
	)
	print("starting with %s fish" % stats.spawn_x_starting_fish)
	print("fish spawn every %s pixels" % stats.spawn_fish_every_x_pixels)
	print("oxygen mult %s" % stats.oxygen_capacity_multiplier)
	print("oxygen total %s/%s" % [stats.oxygen_remaining(), stats.oxygen_capacity()])

	_started = true


func _process(_delta: float) -> void:
	ui_speed_value.text = str(get_pixels_per_second())
	ui_score_value.text = str(get_score())
	ui_oxygen_value.text = str(WTFGlobals.minigame.stats.oxygen_percentage()) + "%"
	ui_weight_value.text = str(floori(stats.total_added_weight()))
	ui_distance_value.text = str(floori(_distance_travelled))
	ui_carry_value.text = "%s/%s" % [floori(stats.carrying), floori(stats.carry_capacity())]


func random_spawnable_fish(
	distance: float, min_height: float, max_height: float, min_speed: float
) -> WTFFishData:
	#todo cache, carefully
	var valid_spawns: Array[WTFFishData]

	var fastest := ""
	var fastest_speed := 0.0

	var slowest := ""
	var slowest_speed := 9999999999.9

	var fish_data := fish_db.get_data()
	for data_key in fish_data:
		var data_val := fish_data[data_key]

		if (
			data_val.base_speed + (min_speed * data_val.player_movement_multiplier * 1.4)
			< slowest_speed
		):
			slowest_speed = (
				data_val.base_speed + (min_speed * data_val.player_movement_multiplier * 1.4)
			)
			slowest = data_key

		var spawnable_x := distance > data_val.spawn.min_spawn_distance
		var spawn_y_range := data_val.spawn.get_spawn_height_range()
		var spawnable_y := min_height <= spawn_y_range.y || max_height >= spawn_y_range.x
		var too_fast := (
			data_val.base_speed + (min_speed * data_val.player_movement_multiplier * 1.4)
			> min_speed
		)
		var too_slow := (
			data_val.base_speed + (min_speed * data_val.player_movement_multiplier * 1.4)
			< min_speed - 2000
		)
		#print("%s is too_fast? %s. %s > %s" % [data_key, too_fast, data_val.base_speed, min_speed])
		if spawnable_x && spawnable_y && !too_fast:
			if (
				data_val.base_speed + (min_speed * data_val.player_movement_multiplier * 1.4)
				> fastest_speed
			):
				fastest_speed = (
					data_val.base_speed + (min_speed * data_val.player_movement_multiplier * 1.4)
				)
				fastest = data_key

			if !too_slow:
				valid_spawns.push_back(data_val)

	if valid_spawns.is_empty() && fastest:
		valid_spawns.push_back(fish_data[fastest])

	if valid_spawns.is_empty() && slowest:
		valid_spawns.push_back(fish_data[slowest])

	assert(!valid_spawns.is_empty())

	#todo, use weightings instead?
	return valid_spawns.pick_random()


func _spawn_fish() -> void:
	#don't spawn when flying
	#todo, allow when we have an upgrade for that (inc. change the spawn data)
	if WTFGlobals.camera.get_bottom() <= WTFConstants.SEALEVEL:
		return

	if $%Entities.get_child_count() > 200:
		return

	var rand_offset_x := randf_range(1, 4) * -stats.scrollspeed.x
	var min_spawn_y := WTFGlobals.camera.get_top() - 320
	var max_spawn_y := WTFGlobals.camera.get_bottom() - 320

	var spawnable_fish := random_spawnable_fish(
		_distance_travelled, min_spawn_y, max_spawn_y, -stats.scrollspeed.x
	)

	if !is_instance_valid(spawnable_fish):
		return

	var f: WTFFish = fish.instantiate()
	f.provide(spawnable_fish)

	# avoid clumping the fish together
	if _first_spawn:
		f.position.x = -stats.scrollspeed.x + randf_range(0, WTFGlobals.camera.get_right() * 2)
	else:
		f.position.x = (_distance_travelled + WTFGlobals.camera.get_right() + rand_offset_x)

	# somewhere within the valid range and also close to the camera
	var height_range := f.data.spawn.get_spawn_height_range()
	f.position.y = randf_range(max(height_range.x, min_spawn_y), min(height_range.y, max_spawn_y))

	# todo, since we move the root entities node
	# we may eventually deal with floating point imprecision
	# should instead move all entity children and let them auto-delete, keeping positions sane
	%Entities.add_child(f)


func _physics_process(delta: float) -> void:
	var base_slow := (-stats.scrollspeed.x / 1000) * stats.total_weight()
	if stats.no_oxygen():
		base_slow *= 8

	if stats.carry_remaining() <= 0:
		base_slow *= 2

	if stats.scrollspeed.x > -300:
		base_slow *= 2
		base_slow += 100

	stats.scroll_slower(base_slow * delta)

	# effectively stopped
	if !stats.scrolling():
		#todo end the run and show summary or ui to restart or buy upgrades
		# hack that acts as a one second timer before the run ends
		var player_done := stats.oxygen_remaining_seconds <= -SECONDS_BEFORE_ENDING_RUN
		if !WTFGlobals.player.underwater() && player_done:
			game_over()

	_distance_travelled += -1 * stats.scrollspeed.x * delta
	_distance_since_spawned += -1 * stats.scrollspeed.x * delta

	#todo replace with good spawning
	while _distance_since_spawned > stats.spawn_fish_every_x_pixels:
		_spawn_fish()
		_distance_since_spawned -= stats.spawn_fish_every_x_pixels
	_first_spawn = false
