# Global SceneLoader class
extends Node

# this is necessary to avoid circular references
const OVERWORLD_SCENE := preload("res://modules/overworld/overworld.tscn")
const EXTRAS_SCENE := preload("res://modules/menu/extras.tscn")
const SHRINE_SETTLEMENT_DATA := preload("res://modules/overworld_locations/shrine/shrine.tres")

var _current_settlement: SettlementData
var _current_minigame: MinigameData

# We control _play_minigame_instantly here because we need a place to store
# the state that doesn't get destroyed when the minigame scene is reloaded.
var _is_immediate_play: bool = false


func _ready() -> void:
	EventBus.exit_minigame.connect(_exit_minigame)


func enable_immediate_play() -> void:
	_is_immediate_play = true


func disable_immediate_play() -> void:
	_is_immediate_play = false


func is_immediate_play() -> bool:
	return _is_immediate_play


func start_minigame(data: MinigameData):
	_current_minigame = data
	get_tree().change_scene_to_packed(data.minigame_scene)


func has_current_minigame() -> bool:
	return _current_minigame != null


func get_current_minigame() -> MinigameData:
	return _current_minigame


func enter_settlement(data: SettlementData):
	get_tree().change_scene_to_packed(OVERWORLD_SCENE)
	_current_settlement = data


func get_current_settlement_data() -> SettlementData:
	return _current_settlement


func return_to_overworld():
	# TODO
	pass


func enter_shrine():
	enter_settlement(SHRINE_SETTLEMENT_DATA)


func enter_extras():
	get_tree().change_scene_to_packed(EXTRAS_SCENE)


func _exit_minigame() -> void:
	if _current_settlement == null:
		print("No settlement context to exit to. Directly running scene?")
		return
	enter_settlement(_current_settlement)
