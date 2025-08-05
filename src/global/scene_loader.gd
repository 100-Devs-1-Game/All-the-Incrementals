# Global SceneLoader class
extends Node

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
	_current_settlement = data
	get_tree().change_scene_to_packed(data.settlement_scene)


func return_to_overworld():
	# TODO
	pass


func _exit_minigame() -> void:
	if _current_settlement == null:
		print("No settlement context to exit to. Directly running scene?")
		return
	get_tree().change_scene_to_packed(_current_settlement.settlement_scene)
