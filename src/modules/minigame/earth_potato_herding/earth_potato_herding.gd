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

@export var bucket: EPHBucketCollision

var potato_score: int = 1


func get_potato_score(_potato: EphAdult) -> int:
	return potato_score


func _initialize() -> void:
	spirit_keeper_brightness.emit(0.0)
	spirit_keeper_speed.emit(0.0)
	destroy_dashing_spirits.emit(0.0)
	destroy_evil_spirits.emit(0.0)
	potato_growth_speed.emit(0.0)
	more_potatoes.emit(0.0)
	slower_spirits.emit(0.0)
	less_dashing_spirits.emit(0.0)
	less_evil_spirits.emit(0.0)
	potato_score = 1
	nutritious_potato.connect(_on_nutrition_changed)


func _on_nutrition_changed(modifier: float):
	potato_score = 1 + int(modifier)


func _start() -> void:
	game_started.emit()
