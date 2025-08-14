class_name EarthPotatoHerdingMinigame
extends BaseMinigame

# Upgrade signals
signal spirit_keeper_brightness(value: float)
signal spirit_keeper_speed(value: float)
signal destroy_dashing_spirits(unlocked: bool)
signal destroy_evil_spirits(unlocked: bool)
signal potato_growth_speed(value: float)
signal nutritious_potato(value: float)
signal more_potatoes(value: float)
signal slower_spirits(value: float)
signal less_dashing_spirits(value: float)
signal less_evil_spirits(value: float)

# Game signals
signal game_started

const BASE_POTATO_SCORE: int = 1
const BASE_POTATO_GROWTH_TIME: float = 30.0
const BASE_POTATO_SPAWNED: int = 10

@export var bucket: EPHBucketCollision

var potato_score: int = 1
var potato_growth_time: float = 30.0


func get_potato_score(_potato: EphAdult) -> int:
	return potato_score


func get_potato_growth_time() -> float:
	return potato_growth_time


func _initialize() -> void:
	spirit_keeper_brightness.emit(0.0)  # Implemented
	spirit_keeper_speed.emit(0.0)  # Implemented
	destroy_dashing_spirits.emit(0.0)
	destroy_evil_spirits.emit(0.0)
	slower_spirits.emit(0.0)
	less_dashing_spirits.emit(0.0)
	less_evil_spirits.emit(0.0)

	potato_growth_time = BASE_POTATO_GROWTH_TIME
	potato_growth_speed.connect(_on_potato_growth_speed_changed)  # Implemented

	potato_score = BASE_POTATO_SCORE
	nutritious_potato.connect(_on_nutrition_changed)  # Implemented

	more_potatoes.connect(_on_more_potatoes_changed)  # Implemented
	_on_more_potatoes_changed(0.0)


func _on_nutrition_changed(modifier: float) -> void:
	potato_score = BASE_POTATO_SCORE + int(modifier)


func _on_potato_growth_speed_changed(modifier: float) -> void:
	potato_growth_time = BASE_POTATO_GROWTH_TIME - BASE_POTATO_GROWTH_TIME * modifier / 100


func _on_more_potatoes_changed(modifier: float) -> void:
	$EphYounglingSpawner._max_spawned_at_once = BASE_POTATO_SPAWNED + int(modifier)
	$EphYounglingSpawner._max_spawned_total = BASE_POTATO_SPAWNED + int(modifier)


func _start() -> void:
	game_started.emit()
