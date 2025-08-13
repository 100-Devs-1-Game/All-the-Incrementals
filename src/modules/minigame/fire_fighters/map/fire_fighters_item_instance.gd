class_name FireFightersMinigameItemInstance
extends Node2D

@export var audio_player_push: AudioStreamPlayer2D

var type: FireFightersMinigameItem
var game: FireFightersMinigame

@onready var sprite: Sprite2D = $Sprite2D


func init(p_type: FireFightersMinigameItem, p_game: FireFightersMinigame):
	type = p_type
	game = p_game
	sprite.texture = type.icon


func _physics_process(_delta: float) -> void:
	if game.is_tile_burning(game.get_tile_at(position)):
		type._on_burn(game, self)
		return

	if type.type == FireFightersMinigameItem.Type.OBJECT:
		var s = self
		var rb: RigidBody2D = s
		assert(audio_player_push)
		if rb.linear_velocity and not audio_player_push.playing:
			audio_player_push.play()
		elif not rb.linear_velocity and audio_player_push.playing:
			audio_player_push.stop()
		audio_player_push.volume_linear = lerp(
			0.0, 1.0, min(rb.linear_velocity.length(), 500) / 500.0
		)


func _on_body_entered(body: Node2D) -> void:
	if type.type == FireFightersMinigameItem.Type.PICKUP:
		var player: FireFightersMinigamePlayer = body
		if player.can_pick_up_item():
			player.pick_up_item(type)
			queue_free()
	else:
		if body is not FireFightersMinigamePlayer:
			type._on_destroy(game, self)
