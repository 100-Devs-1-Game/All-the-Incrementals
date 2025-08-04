class_name FireFightersMinigameItemInstance
extends Node2D

var type: FireFightersMinigameItem

@onready var sprite: Sprite2D = $Sprite2D


func init(p_type: FireFightersMinigameItem):
	type = p_type
	sprite.texture = type.icon


func _on_body_entered(body: Node2D) -> void:
	var player: FireFighterMinigamePlayer = body
	player.pick_up_item(type)
	queue_free()
