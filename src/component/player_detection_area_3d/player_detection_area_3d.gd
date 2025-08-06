@tool
class_name PlayerDetectionArea3D extends Area3D

signal player_detected
signal player_detected_ref(player: SpiritkeeperCharacterController3D)


func _enter_tree() -> void:
	monitorable = false

	set_collision_layer_value(1, false)
	set_collision_mask_value(1, true)


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	body_entered.connect(
		func(body: Node):
			if body is SpiritkeeperCharacterController3D:
				player_detected.emit()
				player_detected_ref.emit(body)
	)
