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
			var binds: Dictionary[String, String] = {}
			for k in GameSettings.keybinds:
				if (GameSettings.keybinds[k] as Array).is_empty():
					continue
				binds[k] = OS.get_keycode_string(GameSettings.keybinds[k][0])
			help_text.text = ""
			help_text.append_text(minigame.data.how_to_play.format(binds))
	)


func _on_exit() -> void:
	help_exited.emit()
