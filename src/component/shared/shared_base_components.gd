extends Node2D

@export var allow_popup_menu: bool = true

@onready var _popup_menu: GamePopupMenu = $CanvasLayer/PopupMenu


func _ready() -> void:
	_popup_menu.visible = false


# this needs to be _unhandled_key_input() because the a sub-popup close key
# may be handled first, in which case, we want to avoid handling it here
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_menu"):
		_popup_menu.visible = !_popup_menu.visible
