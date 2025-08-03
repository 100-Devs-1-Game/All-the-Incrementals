class_name MinigameSharedComponents
extends Node

@export var minigame_node: BaseMinigame
@onready var debug_popup: DebugPopup = $SharedBaseComponents/CanvasLayer/DebugPopup
@onready var game_popup_menu: GamePopupMenu = $SharedBaseComponents/CanvasLayer/PopupMenu


func _ready():
	debug_popup.functions_node = minigame_node
	game_popup_menu.visible = false


func open_upgrade_menu():
	#TODO ...
	pass


func open_main_menu():
	#TODO open minigame main menu ( upgrades, restart, exit )
	pass
