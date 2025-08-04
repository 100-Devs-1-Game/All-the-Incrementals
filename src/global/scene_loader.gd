extends Node

var _current_settlement: SettlementData
var _current_minigame: MinigameData

# Set to true by default so F6 minigame starts don't open the menu
var _play_minigame_instantly: bool = true


func _ready() -> void:
	EventBus.exit_minigame.connect(_exit_minigame)


func start_minigame(data: MinigameData, play_instantly: bool = false):
	_current_minigame = data
	_play_minigame_instantly = play_instantly
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
