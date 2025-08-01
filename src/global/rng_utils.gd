## Random number generator utility class.
class_name RngUtils


## Returns bool [code]true[/code] if [param c] is greater than a random value
## between 0.0 and 1.0, bool [code]false[/code] otherwise.
static func chancef(c: float) -> bool:
	return c > randf()


## Returns [code]true[/code] if [param c] divided by 100 is greater than a
## random value between 0.0 and 1.0, [code]false[/code] otherwise.[br]
## For example:[br]
## [codeblock]
## if chance100(25):
##     print("25% chance to hit")
## [/codeblock]
static func chance100(c: float) -> bool:
	return chancef(c / 100.0)


## Returns [code]true[/code] if [param c] divided by 100 is greater than a
## random value between 0.0 and 1.0 at least once within [param n] number of
## tries, [code]false[/code] otherwise.
static func chance100_or(c: float, n: int) -> bool:
	for i in n:
		if chance100(c):
			return true
	return false


## Returns the number of consecutive times [param c] divided by 100 is
## greater than a new random value between 0.0 and 1.0 each time. The value of
## [param c] must be less than 100.
static func chance100_seq(c: float) -> int:
	assert(c < 100)
	var ctr: int = 0
	while chance100(c):
		ctr += 1
	return ctr


## Returns [code]true[/code] if [param c] is greater than a random value
## between 0.0 and 1.0 using the [RandomNumberGenerator] [param rng],
## [code]false[/code] otherwise.
static func chancef_rng(c: float, rng: RandomNumberGenerator) -> bool:
	return c > rng.randf()


## Returns [code]true[/code] if [param c] divided by 100 is greater than a
## random value between 0.0 and 1.0, [code]false[/code] otherwise.[br]
## For example:[br]
## [codeblock]
## if chance100_rng(25, rng):
##     print("25% chance to hit")
## [/codeblock]
static func chance100_rng(c: float, rng: RandomNumberGenerator) -> bool:
	return chancef_rng(c / 100.0, rng)


## Returns the number of consecutive times [param c] is greater than a new random
## value between 0.0 and 100.0 when reducing [param c] by that random value
## upon each iteration. Also known as [i]meaningful chances > 100%[/i].
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


## Returns the number of consecutive times [param c] is greater than a new random
## value between 0.0 and 100.0 when reducing [param c] by that random value
## upon each iteration, using the [RandomNumberGenerator] [param rng]. Also known
## as [i]meaningful chances > 100%[/i].
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


## Same as [method Array.pick_random] method but using the [RandomNumberGenerator] [param rng].
static func pick_random_rng(arr: Array, rng: RandomNumberGenerator):
	return arr[rng.randi() % arr.size()]


## Same as [method Array.shuffle] but using the [RandomNumberGenerator] [param rng].
static func shuffle_rng(arr: Array, rng: RandomNumberGenerator) -> Array:
	var source_arr = arr.duplicate()
	var result := []
	while not source_arr.is_empty():
		var idx = rng.randi() % source_arr.size()
		result.append(source_arr[idx])
		source_arr.remove_at(idx)
	return result
