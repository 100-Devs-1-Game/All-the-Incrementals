class_name TextFloatSystem
extends Node

const FLOATING_TEXT_SCENE = preload("res://modules/minigame/common/floating_text/float_text.tscn")


## Spawns a floating text instance at a given position with the specified value, then fades away.
static func floating_text(position: Vector2, value: String, parent: Node = null) -> void:
	var instance = FLOATING_TEXT_SCENE.instantiate()
	parent.add_child(instance)
	instance.position = position
	instance.show_value(value)
