extends Node2D

@export var fire_cooking_data: MinigameData
@export var fire_fighters_data: MinigameData
@export var wind_platformer_data: MinigameData
@export var wind_rhythm_data: MinigameData


func _ready() -> void:
	_debug_force_settlement_data()


func debug_start_fire_cooking() -> void:
	SceneLoader.start_minigame(fire_cooking_data)


func debug_start_fire_fighters() -> void:
	SceneLoader.start_minigame(fire_fighters_data)


func debug_start_wind_platformer() -> void:
	SceneLoader.start_minigame(wind_platformer_data)


func debug_start_wind_rhythm() -> void:
	SceneLoader.start_minigame(wind_rhythm_data)


# For temporary debugging purposes, directly set the current settlement. Once
# we have the overworld code working, we'll be setting the settlement naturally.
func _debug_force_settlement_data() -> void:
	var breezekiln_data: SettlementData = load(
		"res://modules/overworld_locations/breezekiln/breezekiln_data.tres"
	)
	SceneLoader._current_settlement = breezekiln_data


func quit_game() -> void:
	get_tree().quit()
