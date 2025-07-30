class_name RngUtils


# chance 0.0 .. 1.0 ( 0 - 100% )
static func chancef(c: float) -> bool:
	return c > randf()


# chance 0.0 .. 100.0 ( 0 - 100% )
static func chance100(c: float) -> bool:
	return chancef(c / 100.0)


# chance 0 - 100, exectued n-times, returns true if any hit
static func chance100_or(c: float, n: int) -> bool:
	for i in n:
		if chancef(c / 100.0):
			return true
	return false


# chance 0 - 100, returns how many time it hit in a row
static func chance100_seq(c: float) -> int:
	assert(c < 100)
	var ctr: int = 0
	while chance100(c):
		ctr += 1
	return ctr


# chance 0.0 .. 1.0 ( 0 - 100% ), for RNG
static func chancef_rng(c: float, rng: RandomNumberGenerator) -> bool:
	return c > rng.randf()


# chance 0.0 .. 100.0 ( 0 - 100% ), for RNG
static func chance100_rng(c: float, rng: RandomNumberGenerator) -> bool:
	return chancef_rng(c / 100.0, rng)


# chance 0 - x, for meaningful chances > 100%
static func multi_chance100(c: float) -> int:
	var ctr := 0
	var total_chance: float = c
	while true:
		var r: float = randf() * 100
		if r < total_chance:
			ctr += 1
			total_chance -= r
		else:
			break

	return ctr


# chance 0 - x, for meaningful chances > 100%, for RNG
static func multi_chance100_rng(c: float, rng: RandomNumberGenerator) -> int:
	var ctr := 0
	var total_chance: float = c
	while true:
		var r: float = rng.randf() * 100
		if r < total_chance:
			ctr += 1
			total_chance -= r
		else:
			break

	return ctr


# same as pick_random() but with RNG
static func pick_random_rng(arr: Array, rng: RandomNumberGenerator):
	return arr[rng.randi() % arr.size()]


# same as shuffle() but with RNG
static func shuffle_rng(arr: Array, rng: RandomNumberGenerator) -> Array:
	var source_arr = arr.duplicate()
	var result := []
	while not source_arr.is_empty():
		var idx = rng.randi() % source_arr.size()
		result.append(source_arr[idx])
		source_arr.remove_at(idx)
	return result
