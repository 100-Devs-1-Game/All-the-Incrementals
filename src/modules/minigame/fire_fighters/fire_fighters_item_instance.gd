class_name FireFightersMinigameItemInstance
extends Node2D

var type: FireFightersMinigameItem

@onready var sprite: Sprite2D = $Sprite2D


func init(p_type: FireFightersMinigameItem):
	type = p_type
	sprite.texture = type.icon


func _on_body_entered(body: Node2D) -> void:
	if type.type == FireFightersMinigameItem.Type.PICKUP:
		var player: FireFightersMinigamePlayer = body
		player.pick_up_item(type)
		queue_free()
	else:
		if body is not FireFightersMinigamePlayer:
			# TODO crap
			type._on_destroy(get_tree().current_scene, self)
