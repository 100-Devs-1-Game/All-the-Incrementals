extends Node2D

var _settlement_data: SettlementData


func start_fire_fighters() -> void:
	var minigame_data = MinigameData.new()
	minigame_data.display_name = "fire_fighters"
	minigame_data.minigame_scene = load("res://modules/minigame/fire_fighters/fire_fighters.tscn")
	_debug_force_settlement_data()
	SceneLoader.start_minigame(minigame_data)


# For temporary debugging purposes, directly set the current settlement. Once
# we have the overworld code working, we'll be setting the settlement naturally.
func _debug_force_settlement_data() -> void:
	_settlement_data = SettlementData.new()
	_settlement_data.display_name = "breezekiln"
	_settlement_data.settlement_scene = load(
		"res://modules/overworld_locations/breezekiln/breezekiln.tscn"
	)
	SceneLoader._current_settlement = _settlement_data
