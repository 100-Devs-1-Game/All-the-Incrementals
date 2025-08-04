extends CanvasLayer

@export var minigames: Array[MinigameData]

@onready var vbox: VBoxContainer = $VBoxContainer


func _ready() -> void:
	# Create buttons for all minigames
	for minigame in minigames:
		var button := Button.new()
		button.text = minigame.display_name
		vbox.add_child(button)
		button.pressed.connect(start_minigame.bind(minigame))


func start_minigame(data: MinigameData):
	var settlement_data: SettlementData = SettlementData.new()
	settlement_data.settlement_scene = load("res://modules/minigame/example/overworld.tscn")
	SceneLoader._current_settlement = settlement_data
	SceneLoader.start_minigame(data)
