class_name WTFCamera2D
extends Camera2D

@export var player: WTFPlayer

var _visible_rect: Rect2
var _updated_rect: bool = false


func get_visible_rect() -> Rect2:
	if _updated_rect:
		return _visible_rect

	var viewport_size = get_viewport_rect().size
	_visible_rect.position = get_screen_center_position() - viewport_size * 0.5 * zoom
	_visible_rect.size = viewport_size * zoom
	return _visible_rect


func _process(_delta: float) -> void:
	_updated_rect = false
	#todo: idk if it should follow the player tbh?
	#global_position = player.global_position
