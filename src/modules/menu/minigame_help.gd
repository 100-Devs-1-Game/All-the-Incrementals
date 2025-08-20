class_name MinigameHelp
extends Control

signal help_exited

var minigame: BaseMinigame

@onready var help_text: RichTextLabel = %HelpText
@onready var exit: Button = %Exit


func _ready() -> void:
	visible = false
	exit.pressed.connect(_on_exit)


func setup(p_minigame: BaseMinigame) -> void:
	minigame = p_minigame
	minigame.playing.connect(
		func():
			help_text.text = ""
			help_text.append_text(minigame.data.how_to_play)
	)


func _on_exit() -> void:
	help_exited.emit()
