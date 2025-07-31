class_name PerformanceUtils


#
# Usage:
#   var timer:= Stopwatch.new()
#   for i in 100000:
#	  print(i)
#	timer.stop("For loop took")
#
# Output:
#   For loop took 58ms
#
#
class Stopwatch:
	var time: int
	var pause: bool:
		set(b):
			pause = b
			if pause:
				pause_time = Time.get_ticks_msec()
			else:
				exclude_time += Time.get_ticks_msec() - pause_time

	var pause_time: int
	var exclude_time: int

	func _init():
		time = Time.get_ticks_msec()

	func stop(prefix: String = ""):
		var delta = get_elapsed_msecs()
		print(prefix.rstrip(" ") + " ", delta, "ms")

	func get_elapsed_msecs() -> int:
		return Time.get_ticks_msec() - time - exclude_time

	func get_elapsed_secs() -> float:
		return get_elapsed_msecs() / 1000.0


#
# Usage:
#
#  func _process():
#    PerformanceUtils.TrackAverage.start_tracking("for loop")
#    for i in 100000:
#      print(i)
#    PerformanceUtils.TrackAverage.stop_tracking("for loop")
#
#  func on_quit():
#    PerformanceUtils.TrackAverage.dump("for loop")
#
#
# Output:
#   Average Time [ for loop ]: 58ms
#
#
class TrackAverage:
	const KEY_TIMER = "timer"
	const KEY_COUNTER = "ctr"
	const KEY_TOTAL_TIME = "total"

	static var dict: Dictionary

	static func start_tracking(key: String):
		var timer := Stopwatch.new()
		if not dict.has(key):
			dict[key] = {}
		var key_dict: Dictionary = dict[key]

		key_dict[KEY_TIMER] = timer

		if not key_dict.has(KEY_TOTAL_TIME):
			key_dict[KEY_TOTAL_TIME] = 0

		if not key_dict.has(KEY_COUNTER):
			key_dict[KEY_COUNTER] = 0

	static func stop_tracking(key: String):
		assert(dict.has(key) and (dict[key] as Dictionary).has(KEY_TIMER))
		var key_dict: Dictionary = dict[key]
		var msecs: int = (key_dict[KEY_TIMER] as Stopwatch).get_elapsed_msecs()
		key_dict.erase(KEY_TIMER)

		key_dict[KEY_TOTAL_TIME] += msecs
		key_dict[KEY_COUNTER] += 1

	static func dump(key: String):
		assert(dict.has(key))
		var key_dict: Dictionary = dict[key]

		var ctr: int = key_dict[KEY_COUNTER]
		if ctr == 0:
			return

		var avg: int = key_dict[KEY_TOTAL_TIME] / ctr

		print("Average Time [ %s ]: %dms" % [key, avg])
