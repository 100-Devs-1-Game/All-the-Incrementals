class_name TextFloatSystem
extends Node

enum AnimationStyle { FLOAT, SCALE, BOUNCE }  #A little messy, I'll clean it up later :D

const FLOATING_TEXT_SCENE := preload("res://modules/minigame/common/floating_text/float_text.tscn")


## Spawns a floating text instance at a given position with the specified value.
static func floating_text(
	position: Vector2,
	value: String,
	parent: Node,
	style: AnimationStyle = AnimationStyle.FLOAT,
	rainbow: bool = false
) -> void:
	if parent.get_tree().root == parent:
		assert(false)  # Don't add to the root; it causes lag & visual issues

	var instance := FLOATING_TEXT_SCENE.instantiate()

	parent.add_child(instance)
	instance.position = position
	instance.reset_physics_interpolation()
	instance.show_value(value, style, rainbow)
