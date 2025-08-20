class_name Altar
extends Node3D

enum Element { EARTH, FIRE, WATER, WIND }

@export var element: Element


func get_stats() -> AltarStats:
	return SaveGameManager.world_state.get_altar_stats(element)


func _on_interaction_component_interacted_with(_player: SpiritkeeperCharacterController3D) -> void:
	pass  # Replace with function body.
