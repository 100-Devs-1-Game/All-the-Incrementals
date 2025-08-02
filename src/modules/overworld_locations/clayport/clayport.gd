extends Node2D

var _settlement_data: SettlementData


func debug_start_earth_potato_herding() -> void:
	var data: MinigameData = load(
		"res://modules/minigame/earth_potato_herding/data/earth_potato_herding_data.tres"
	)
	_debug_force_settlement_data()
	SceneLoader.start_minigame(data)


# For temporary debugging purposes, directly set the current settlement. Once
# we have the overworld code working, we'll be setting the settlement naturally.
func _debug_force_settlement_data() -> void:
	_settlement_data = SettlementData.new()
	_settlement_data.display_name = "clayport"
	_settlement_data.settlement_scene = load(
		"res://modules/overworld_locations/clayport/clayport.tscn"
	)
	SceneLoader._current_settlement = _settlement_data
