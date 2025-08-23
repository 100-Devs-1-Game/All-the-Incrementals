extends Node3D

@export var target_settlement: SettlementData

@onready var interaction_component: InteractionComponent3D = $InteractionComponent3D


func _ready() -> void:
	var tmp_str: String
	if target_settlement:
		tmp_str = "enter " + target_settlement.display_name
	else:
		tmp_str = "return to Shrine"

	interaction_component.action_ui_suffix = tmp_str


func _on_interaction_component_3d_interacted_with(
	_player: SpiritkeeperCharacterController3D
) -> void:
	SceneLoader.enter_settlement.call_deferred(
		(
			target_settlement
			if target_settlement
			else load("res://modules/overworld_locations/shrine/shrine.tres")
		)
	)
