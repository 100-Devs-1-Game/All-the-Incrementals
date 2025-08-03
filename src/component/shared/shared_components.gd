extends Node2D

@onready var _popup_menu: GamePopupMenu = $PopupMenu


func _ready() -> void:
	_popup_menu.visible = false


func _input(event: InputEvent) -> void:
	# ignore escape if the settings menu is open
	if !_popup_menu.settings.visible and event.is_action_pressed("toggle_popup_menu"):
		_popup_menu.visible = !_popup_menu.visible
