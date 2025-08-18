class_name SettlementExit extends Node3D

signal exited_settlement

const SETTLEMENT_EXIT_GROUP := &"settlement_exit"


func _ready() -> void:
	add_to_group(SETTLEMENT_EXIT_GROUP)


func exit_settlement(_player: SpiritkeeperCharacterController3D) -> void:
	exited_settlement.emit()
