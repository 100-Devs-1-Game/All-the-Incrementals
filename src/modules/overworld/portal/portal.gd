extends Node3D

@export var target_settlement: SettlementData

@onready var interaction_component: InteractionComponent3D = $InteractionComponent3D


func _ready() -> void:
	interaction_component.action_ui_suffix = "enter " + target_settlement.display_name


func _on_interaction_component_3d_interacted_with(
	_player: SpiritkeeperCharacterController3D
) -> void:
	SceneLoader.enter_settlement(target_settlement)
