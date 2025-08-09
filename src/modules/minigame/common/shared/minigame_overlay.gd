class_name MinigameOverlay
extends PanelContainer

@export var enable_score_display: bool = false:
	set(b):
		enable_score_display = b
		if not is_inside_tree():
			await ready
		_score_panel.visible = b

@export var enable_countdown_display: bool = false:
	set(b):
		enable_countdown_display = b
		if not is_inside_tree():
			await ready
		_countdown_panel.visible = b

var minigame: BaseMinigame

@onready var _score_panel: HBoxContainer = %ScorePanel
@onready var _score_label: Label = %ScoreLabel
@onready var _score_icon: TextureRect = %ScoreIcon
@onready var _score_value: Label = %ScoreValue

@onready var _countdown_panel: HBoxContainer = %CountdownPanel
@onready var _countdown_label: Label = %CountdownLabel
@onready var _countdown_icon: TextureRect = %CountdownIcon
@onready var _countdown_value: Label = %CountdownValue


func update():
	if enable_score_display:
		_update_score(minigame.get_score())
	if enable_countdown_display and minigame.has_countdown:
		_update_countdown(minigame.get_time_left())


func _update_score(score: int):
	_score_value.text = str(score)


func _update_countdown(time_left: float):
	_countdown_value.text = "%.1fs" % [time_left]
