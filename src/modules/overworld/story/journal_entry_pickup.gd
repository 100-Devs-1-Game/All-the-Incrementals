class_name JournalEntryPickup
extends Node3D

@export var data: JournalEntryData

@onready var page: MeshInstance3D = $HoveringPage


func _on_interaction_component_interacted_with(_player: SpiritkeeperCharacterController3D) -> void:
	EventBus.request_journal_page_display.emit(data)
	queue_free()


func _ready() -> void:
	((page.mesh as QuadMesh).material as ShaderMaterial).set_shader_parameter(
		&"texture_albedo", data.page
	)
