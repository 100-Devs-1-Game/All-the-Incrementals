class_name MinigameSharedComponents
extends Node

@export var minigame_node: BaseMinigame
@export var debug_popup: DebugPopup
@export var game_popup_menu: GamePopupMenu
@export var minigame_menu: MinigameMenu
@export var minigame_overlay: MinigameOverlay
@export var debug_minigame_upgrades: DebugMinigameUpgrades


func _ready():
	debug_popup.functions_node = minigame_node
	minigame_menu.minigame = minigame_node
	debug_minigame_upgrades.minigame = minigame_node
	game_popup_menu.visible = false


func open_upgrade_menu():
	#TODO ...
	pass


func _process(_delta: float) -> void:
	if minigame_node:
		assert(minigame_overlay)
		minigame_overlay.update()
