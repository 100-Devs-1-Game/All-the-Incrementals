extends Node2D

@export var earth_potato_herding_data: MinigameData
@export var earth_towers_data: MinigameData
@export var water_diving_data: MinigameData
@export var water_target_fishing_data: MinigameData
@export var water_rowing_rapids_data: MinigameData


func _ready() -> void:
	_debug_force_settlement_data()


func debug_start_earth_potato_herding() -> void:
	SceneLoader.start_minigame(earth_potato_herding_data)


func debug_start_earth_towers() -> void:
	SceneLoader.start_minigame(earth_towers_data)


func debug_start_water_diving() -> void:
	SceneLoader.start_minigame(water_diving_data)


func debug_start_water_target_fishing() -> void:
	SceneLoader.start_minigame(water_target_fishing_data)

func debug_start_rowing_rapids() -> void:
	SceneLoader.start_minigame(water_rowing_rapids_data)

# For temporary debugging purposes, directly set the current settlement. Once
# we have the overworld code working, we'll be setting the settlement naturally.
func _debug_force_settlement_data() -> void:
	var clayport_data: SettlementData = load(
		"res://modules/overworld_locations/clayport/clayport_data.tres"
	)
	SceneLoader._current_settlement = clayport_data


func quit_game() -> void:
	get_tree().quit()
