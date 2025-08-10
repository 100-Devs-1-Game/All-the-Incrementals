class_name EPHRandomPositionSpawner
extends RandomPositionSpawner

# Points that define spawn rate over time. X value should be non-descending.
@export var points: Array[Vector2] = [Vector2.ZERO, Vector2.ONE]
@export var cur_mode: OvertimeMode = OvertimeMode.FINAL_RATE

@export var time_multiplier: float = 20.0
@export var autospawn: bool = false
# I couldn't get Path2D or Curve to work the way they should,
# so here's an array of points for now.

# How spawn rate behaves when last point is passed
var _total_delta_time: float = 0
enum OvertimeMode { ONESHOT = 0, REPEAT = 1, FINAL_RATE = 2, BEGIN_RATE = 3 }


func _set_up() -> void:
	_init_random_point_generator()
	_total_delta_time = 0.0
	if not autospawn:
		_time_since_last_spawn = _spawn_cooldown


#region ======================== PRIVATE METHODS ===============================


func _physics_process(delta: float) -> void:
	_total_delta_time += delta
	if _use_physics_process_to_spawn:
		var multiplier := get_current_rate()
		_time_since_last_spawn -= delta * multiplier
		_try_spawn()


func _try_spawn() -> void:
	if _time_since_last_spawn > 0:
		return

	_time_since_last_spawn = _spawn_cooldown

	spawn()


#endregion


func get_current_rate() -> float:
	# Get multiplier-adjusted current time.
	var cur_time := _total_delta_time
	cur_time /= time_multiplier

	# Get current time.
	var time_size := points[-1].x
	if cur_time > time_size:
		match cur_mode:
			OvertimeMode.ONESHOT:
				return 0.0  # No spawning.
			OvertimeMode.REPEAT:
				cur_time -= int(cur_time)
			OvertimeMode.FINAL_RATE:
				cur_time = 1.0
			OvertimeMode.BEGIN_RATE:
				cur_time = 0.0

	# Find first interval between points that includes the current time.
	var res := Vector2.ZERO
	for val in points:
		if val.x > cur_time:
			# Find point on line that has the right x-value.
			var diff := (cur_time - res.x) / (val.x - res.x)
			res += (val - res) * diff
			break
		res = val
		if val.x == cur_time:
			break  #It's exactly on the dot.
	# Hey, as long as it works...
	# print([_total_delta_time,cur_time,time_multiplier,cur_time,res])
	return res.y
