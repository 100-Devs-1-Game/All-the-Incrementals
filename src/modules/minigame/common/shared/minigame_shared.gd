class_name MinigameSharedComponents
extends Node

const NODE_NAME = "SharedComponents"

@export var minigame_node: BaseMinigame


func _ready():
	$CanvasLayer/DebugPopup.functions_node = minigame_node


func open_upgrade_menu():
	#TODO ...
	pass


func open_main_menu():
	#TODO open minigame main menu ( upgrades, restart, exit )
	pass
