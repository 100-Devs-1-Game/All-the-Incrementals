class_name WTFClearColour
extends Node2D

@export var clear_colour: Color
var _cached_clear_colour: Color


func _enter_tree() -> void:
	_cached_clear_colour = RenderingServer.get_default_clear_color()
	RenderingServer.set_default_clear_color(clear_colour)


func _exit_tree() -> void:
	RenderingServer.set_default_clear_color(_cached_clear_colour)
