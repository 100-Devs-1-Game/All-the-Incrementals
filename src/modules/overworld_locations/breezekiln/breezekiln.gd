extends Node2D


func debug_start_fire_cooking() -> void:
	var data: MinigameData = load("res://modules/minigame/fire_cooking/data/fire_cooking_data.tres")
	_debug_force_settlement_data()
	SceneLoader.start_minigame(data)


func debug_start_fire_fighters() -> void:
	var data: MinigameData = load(
		"res://modules/minigame/fire_fighters/data/fire_fighters_data.tres"
	)
	_debug_force_settlement_data()
	SceneLoader.start_minigame(data)


func debug_start_wind_platformer() -> void:
	var data: MinigameData = load(
		"res://modules/minigame/wind_platformer/data/wind_platformer_data.tres"
	)
	_debug_force_settlement_data()
	SceneLoader.start_minigame(data)


func debug_start_wind_rhythm() -> void:
	var data: MinigameData = load("res://modules/minigame/wind_rhythm/data/wind_rhythm_data.tres")
	_debug_force_settlement_data()
	SceneLoader.start_minigame(data)


# For temporary debugging purposes, directly set the current settlement. Once
# we have the overworld code working, we'll be setting the settlement naturally.
func _debug_force_settlement_data() -> void:
	var data: SettlementData = load(
		"res://modules/overworld_locations/breezekiln/breezekiln_data.tres"
	)
	SceneLoader._current_settlement = data
