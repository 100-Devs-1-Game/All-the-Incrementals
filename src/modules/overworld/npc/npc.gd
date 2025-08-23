class_name NPC
extends Node3D

@export var dialog: NPCDialog


func _on_interacted_with(player: SpiritkeeperCharacterController3D):
	player.start_dialog(dialog)
