class_name MinigameSharedComponents
extends Node

@export var debug_popup: DebugPopup
@export var minigame_menu: MinigameMenu
@export var minigame_help: MinigameHelp
@export var minigame_highscores: HighScores
@export var minigame_overlay: MinigameOverlay
@export var debug_minigame_upgrades: DebugMinigameUpgrades

var minigame_node: BaseMinigame


func _ready():
	minigame_node = get_parent()
	assert(minigame_node != null)
	debug_popup.functions_node = minigame_node
	#minigame_menu.init(minigame_node)
	minigame_menu.minigame = minigame_node
	minigame_highscores.minigame = minigame_node
	debug_minigame_upgrades.minigame = minigame_node
	minigame_overlay.minigame = minigame_node

	minigame_help.setup(minigame_node)

	minigame_menu.help_pressed.connect(
		func():
			minigame_help.visible = true
			minigame_menu.visible = false
	)

	minigame_help.help_exited.connect(
		func():
			minigame_help.visible = false
			minigame_menu.visible = true
	)


func _input(event: InputEvent) -> void:
	if !minigame_menu.visible and event.is_action_pressed("exit_menu"):
		minigame_menu.open_menu()


func _process(_delta: float) -> void:
	if minigame_node:
		assert(minigame_overlay)
		minigame_overlay.update()
