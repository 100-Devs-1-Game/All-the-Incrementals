class_name JournalEntryPickup
extends Node3D

@export var data: JournalEntryData


func _on_interaction_component_interacted_with(_player: SpiritkeeperCharacterController3D) -> void:
	EventBus.request_journal_page_display.emit(data)
	queue_free()
