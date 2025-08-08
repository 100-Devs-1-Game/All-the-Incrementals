class_name FireFightersMinigameItemInstance
extends Node2D

var type: FireFightersMinigameItem
var game: FireFightersMinigame

@onready var sprite: Sprite2D = $Sprite2D


func init(p_type: FireFightersMinigameItem, p_game: FireFightersMinigame):
	type = p_type
	game = p_game
	sprite.texture = type.icon


func _on_body_entered(body: Node2D) -> void:
	if type.type == FireFightersMinigameItem.Type.PICKUP:
		var player: FireFightersMinigamePlayer = body
		if player.can_pick_up_item():
			player.pick_up_item(type)
			queue_free()
	else:
		if body is not FireFightersMinigamePlayer:
			# TODO crap
			type._on_destroy(game, self)
