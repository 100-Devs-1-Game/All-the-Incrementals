extends Node2D


func debug_start_earth_potato_herding() -> void:
	var data: MinigameData = load(
		"res://modules/minigame/earth_potato_herding/data/earth_potato_herding_data.tres"
	)
	_debug_force_settlement_data()
	SceneLoader.start_minigame(data)


func debug_start_earth_towers() -> void:
	var data: MinigameData = load("res://modules/minigame/earth_towers/data/earth_towers_data.tres")
	_debug_force_settlement_data()
	SceneLoader.start_minigame(data)


func debug_start_water_diving() -> void:
	var data: MinigameData = load("res://modules/minigame/water_diving/data/water_diving_data.tres")
	_debug_force_settlement_data()
	SceneLoader.start_minigame(data)


func debug_start_water_target_fishing() -> void:
	var data: MinigameData = load(
		"res://modules/minigame/water_target_fishing/data/water_target_fishing_data.tres"
	)
	_debug_force_settlement_data()
	SceneLoader.start_minigame(data)


# For temporary debugging purposes, directly set the current settlement. Once
# we have the overworld code working, we'll be setting the settlement naturally.
func _debug_force_settlement_data() -> void:
	var data: SettlementData = load("res://modules/overworld_locations/clayport/clayport_data.tres")
	SceneLoader._current_settlement = data
