extends Node

var _current_settlement: SettlementData
var _current_minigame: MinigameData


func _ready() -> void:
	EventBus.connect(EventBus.exit_minigame.get_name(), Callable(self, "_exit_minigame"))


func start_minigame(data: MinigameData):
	_current_minigame = data
	get_tree().change_scene_to_packed(data.minigame_scene)


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
