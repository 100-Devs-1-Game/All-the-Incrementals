class_name MinigameSharedComponents
extends Node

@export var minigame_node: BaseMinigame
@export var debug_popup: DebugPopup
@export var game_popup_menu: GamePopupMenu
@export var minigame_menu: MinigameMenu


func _ready():
	debug_popup.functions_node = minigame_node
	game_popup_menu.visible = false


func open_upgrade_menu():
	#TODO ...
	pass


func open_main_menu():
	minigame_menu.open_menu()
