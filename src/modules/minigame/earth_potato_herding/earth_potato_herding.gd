class_name EarthPotatoHerdingMinigame
extends BaseMinigame

# Upgrade signals
signal nutritious_potato(value: float)
signal spirit_keeper_brightness(value: float)
signal spirit_keeper_speed(value: float)
signal potato_growth_speed(value: float)
signal player_aura_level(value: float)

# Game signals
signal game_started

@export var bucket: EPHBucketCollision

var potato_score: int = 1


func get_potato_score(_potato: EphAdult) -> int:
	return potato_score


func _initialize() -> void:
	assert(bucket)
	bucket.start_effect(60.0)
	spirit_keeper_brightness.emit(0.0)
	spirit_keeper_speed.emit(0.0)
	potato_growth_speed.emit(0.0)
	player_aura_level.emit(0.0)
	nutritious_potato.connect(_on_nutrition_changed)


func _on_nutrition_changed(modifier: float):
	potato_score = 1 + int(modifier)


func _start() -> void:
	game_started.emit()
