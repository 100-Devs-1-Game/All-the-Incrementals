class_name WTFStats
extends Resource

# data that changes during the run
# todo maybe move to minigame? but nice to have all the helper funcs together atm
var scrollspeed: Vector2
var weight: float
var carrying: int
var oxygen_remaining_seconds: float

# data that changes due to upgrades/rebalancing
var scrollspeed_initial: Vector2 = Vector2(-1000, 0)
var speedboost_multiplier: float = 1
var speedboost_flat: float = 0

var score_multiplier: float = 1
var score_flat: float = 0
var weight_multiplier: float = 1
var weight_initial: float = 100
var carry_initial: int = 5
var carry_flat: int = 0

var oxygen_capacity_seconds: float = 3
var oxygen_capacity_multiplier: float = 1
var oxygen_capacity_flat: float = 0

var spawn_fish_every_x_pixels: float = 300
var spawn_x_starting_fish: float = 3
var fish_movespeed_multiplier: float = 1
var fish_movespeed_flat: float = 0
var fish_spawn_above_sealevel: bool = false
var fish_can_fly: bool = false
var spawnable_fish_min_depth_offset: float = 0
var spawnable_fish_min_distance_offset: float = 0

var spawn_boats: bool = true
var spawn_boats_every_x_pixels: float = 5000
var spawn_boats_chance: float = 5
var boats_carry_capacity: int = 5
var boats_movespeed_initial: float = 2000
var boats_movespeed_multiplier: float = 1
var boats_movespeed_flat: float = 0

var spawn_junk_every_x_pixels: float = 100


func _init() -> void:
	reset()


func reset() -> void:
	scrollspeed = scrollspeed_initial
	#we don't add the initial amount to avoid it in the UI
	weight = 0
	carrying = 0
	oxygen_remaining_seconds = oxygen_capacity()


func _apply_speedboost(amount: float) -> float:
	return (amount * speedboost_multiplier) + speedboost_flat


func scrolling() -> bool:
	return scrollspeed.x < 0


func stop_scrolling() -> void:
	scrollspeed = Vector2.ZERO


func scroll_faster(amount: float) -> void:
	scrollspeed.x -= _apply_speedboost(amount) * 0.6
	scrollspeed.x = min(0, scrollspeed.x)


func scroll_slower(amount: float) -> void:
	scrollspeed.x += amount
	scrollspeed.x = min(0, scrollspeed.x)


func total_weight() -> float:
	return weight_initial + total_added_weight()


func total_added_weight() -> float:
	return weight * weight_multiplier


func consume_oxygen(seconds: float) -> void:
	oxygen_remaining_seconds -= seconds


func refill_oxygen(seconds: float) -> void:
	oxygen_remaining_seconds = max(0, oxygen_remaining_seconds)
	oxygen_remaining_seconds += 3 * seconds
	oxygen_remaining_seconds = min(oxygen_remaining_seconds, oxygen_capacity())


func no_oxygen() -> bool:
	return oxygen_remaining_seconds <= 0


func oxygen_percentage() -> int:
	return floori((max(0, oxygen_remaining_seconds) / oxygen_capacity()) * 100.0)


func oxygen_capacity() -> float:
	return (oxygen_capacity_seconds * oxygen_capacity_multiplier) + oxygen_capacity_flat


func oxygen_remaining() -> float:
	return oxygen_remaining_seconds


func carry_capacity() -> float:
	return float(carry_initial) + float(carry_flat)


func carry_remaining() -> float:
	return carry_capacity() - float(carrying)


func try_carry() -> bool:
	if carry_remaining() <= 0:
		return false

	carrying = carrying + 1
	return true
