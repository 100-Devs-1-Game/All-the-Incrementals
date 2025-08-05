class_name WTFMinigame
extends BaseMinigame

const SECONDS_BEFORE_ENDING_RUN: float = 1

@export var fish: PackedScene

var stats: WTFStats

var _distance_travelled = 0
var _distance_since_spawned = 0

@onready var fish_db: WTFFishDB = %WTFFishDB

@onready var ui_speed_value: RichTextLabel = %UISpeedValue
@onready var ui_score_value: RichTextLabel = %UIScoreValue
@onready var ui_oxygen_value: RichTextLabel = %UIOxygenValue
@onready var ui_weight_value: RichTextLabel = %UIWeightValue
@onready var ui_distance_value: RichTextLabel = %UIDistanceValue


func get_pixels_per_second() -> int:
	return floori(-stats.scrollspeed.x)


func _enter_tree() -> void:
	WTFGlobals.minigame = self
	stats = WTFStats.new()

	## yyyy does it stutter thoooo
	# I can't find any magic number that solves it :(
	process_priority = 55555
	process_physics_priority = 55555


func _exit_tree() -> void:
	WTFGlobals.minigame = null


func _start() -> void:
	# give it an initial amount so we can get some fishies going
	_distance_since_spawned = stats.spawn_fish_every_x_pixels * stats.spawn_x_starting_fish


func _process(_delta: float) -> void:
	ui_speed_value.text = str(get_pixels_per_second())
	ui_score_value.text = str(get_score())
	ui_oxygen_value.text = str(WTFGlobals.minigame.stats.oxygen_percentage()) + "%"
	ui_weight_value.text = str(floori(stats.total_weight()))
	ui_distance_value.text = str(floori(_distance_travelled))


func random_spawnable_fish(distance: float, min_height: float, max_height: float) -> WTFFishData:
	#todo cache, carefully
	var valid_spawns: Array[WTFFishData]

	var data := fish_db.get_data()
	for data_key in data:
		var data_val := data[data_key]
		var spawnable_x := distance > data_val.spawn.min_spawn_distance
		var spawn_y_range := data_val.spawn.get_spawn_height_range()
		var spawnable_y := min_height <= spawn_y_range.y || max_height >= spawn_y_range.x
		if spawnable_x && spawnable_y:
			valid_spawns.push_back(data_val)

	#todo, use weightings instead?
	return valid_spawns.pick_random()


func _spawn_fish() -> void:
	#don't spawn when flying
	#todo, allow when we have an upgrade for that (inc. change the spawn data)
	if WTFGlobals.camera.get_bottom() <= WTFConstants.SEALEVEL:
		return

	var rand_offset_x := randf_range(1, 4) * -stats.scrollspeed.x
	var min_spawn_y := WTFGlobals.camera.get_top() - 320
	var max_spawn_y := WTFGlobals.camera.get_bottom() - 320

	var spawnable_fish := random_spawnable_fish(_distance_travelled, min_spawn_y, max_spawn_y)

	if !is_instance_valid(spawnable_fish):
		return

	var f: WTFFish = fish.instantiate()
	f.data = spawnable_fish

	# avoid clumping the fish together
	f.position.x = (_distance_travelled + WTFGlobals.camera.get_right() + rand_offset_x)

	# somewhere within the valid range and also close to the camera
	var height_range := f.data.spawn.get_spawn_height_range()
	f.position.y = randf_range(max(height_range.x, min_spawn_y), min(height_range.y, max_spawn_y))

	# todo, since we move the root entities node
	# we may eventually deal with floating point imprecision
	# should instead move all entity children and let them auto-delete, keeping positions sane
	%Entities.add_child(f)


func _physics_process(delta: float) -> void:
	stats.scroll_slower(stats.total_weight() * delta)

	# effectively stopped
	if !stats.scrolling():
		#todo end the run and show summary or ui to restart or buy upgrades
		# hack that acts as a one second timer before the run ends
		var player_done := stats.oxygen_remaining_seconds <= -SECONDS_BEFORE_ENDING_RUN
		if !WTFGlobals.player.underwater() && player_done:
			get_tree().reload_current_scene()

	_distance_travelled += -1 * stats.scrollspeed.x * delta
	_distance_since_spawned += -1 * stats.scrollspeed.x * delta

	#todo replace with good spawning
	while _distance_since_spawned > stats.spawn_fish_every_x_pixels:
		_spawn_fish()
		_distance_since_spawned -= stats.spawn_fish_every_x_pixels
