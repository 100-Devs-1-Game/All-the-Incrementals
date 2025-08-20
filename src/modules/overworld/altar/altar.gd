class_name Altar
extends Node3D

enum Element { EARTH, FIRE, WATER, WIND }

@export var element: Element

@onready var ui: AltarUI = $UI


func _ready() -> void:
	ui.init(get_stats())


func _on_interaction_component_interacted_with(_player: SpiritkeeperCharacterController3D) -> void:
	ui.show()
	ui.update()


func get_stats() -> AltarStats:
	return SaveGameManager.world_state.get_altar_stats(element)
