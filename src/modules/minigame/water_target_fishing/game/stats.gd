class_name WTFStats
extends Resource

var scrollspeed: Vector2

var score_multiplier: float
var weight_multiplier: float
var weight_initial: float
var weight: float

var oxygen_capacity_seconds: float
var oxygen_remaining_seconds: float

var spawn_fish_every_x_pixels: float
var spawn_x_starting_fish: float


func _init() -> void:
	scrollspeed = Vector2(-200, 0)

	score_multiplier = 1.0
	weight_multiplier = 1.0
	weight_initial = 100
	weight = 0

	oxygen_capacity_seconds = 3
	oxygen_remaining_seconds = 3

	spawn_fish_every_x_pixels = 300
	spawn_x_starting_fish = 3


func scrolling() -> bool:
	return scrollspeed.x < 0


func stop_scrolling() -> void:
	scrollspeed = Vector2.ZERO


func scroll_faster(amount: float) -> void:
	scrollspeed.x -= amount
	scrollspeed.x = min(0, scrollspeed.x)


func scroll_slower(amount: float) -> void:
	scrollspeed.x += amount
	scrollspeed.x = min(0, scrollspeed.x)


func total_weight() -> float:
	return weight_initial + (weight * weight_multiplier)


func consume_oxygen(seconds: float) -> void:
	oxygen_remaining_seconds -= seconds


func refill_oxygen(seconds: float) -> void:
	oxygen_remaining_seconds = max(0, oxygen_remaining_seconds)
	oxygen_remaining_seconds += 3 * seconds
	oxygen_remaining_seconds = min(oxygen_remaining_seconds, oxygen_capacity_seconds)


func no_oxygen() -> bool:
	return oxygen_remaining_seconds <= 0


func oxygen_percentage() -> int:
	return floori((max(0, oxygen_remaining_seconds) / oxygen_capacity_seconds) * 100.0)
