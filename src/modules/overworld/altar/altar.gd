class_name Altar
extends Node3D

enum Element { EARTH, FIRE, WATER, WIND }

@export var element: Element

@export var earth_material: StandardMaterial3D
@export var fire_material: StandardMaterial3D
@export var water_material: StandardMaterial3D
@export var wind_material: StandardMaterial3D

@onready var ui: AltarUI = $UI
@onready var diamond: MeshInstance3D = %Diamond


func _ready() -> void:
	ui.init(get_stats())

	var material: StandardMaterial3D
	match element:
		Element.EARTH:
			material = earth_material
		Element.FIRE:
			material = fire_material
		Element.WATER:
			material = water_material
		Element.WIND:
			material = wind_material

	diamond.set_surface_override_material(0, material)


func _on_interaction_component_interacted_with(_player: SpiritkeeperCharacterController3D) -> void:
	ui.show()
	ui.update()


func get_stats() -> AltarStats:
	return SaveGameManager.world_state.get_altar_stats(element)
