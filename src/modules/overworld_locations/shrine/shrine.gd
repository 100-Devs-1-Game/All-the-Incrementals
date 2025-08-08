extends Node


func _ready() -> void:
	_debug_force_settlement_data()


func debug_enter_breezekiln() -> void:
	SceneLoader.enter_breezekiln()


func debug_enter_clayport() -> void:
	SceneLoader.enter_clayport()


# For temporary debugging purposes, directly set the current settlement. Once
# we have the overworld code working, we'll be setting the settlement naturally.
func _debug_force_settlement_data() -> void:
	var clayport_data: SettlementData = load("res://modules/overworld_locations/shrine/shrine.tres")
	SceneLoader._current_settlement = clayport_data


func quit_game() -> void:
	get_tree().quit()
