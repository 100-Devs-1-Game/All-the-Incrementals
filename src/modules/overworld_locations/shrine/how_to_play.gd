extends Node3D

var tween: Tween

@onready var label_3d: Label3D = $Label3D
@onready var ui: CanvasLayer = $CanvasLayer


func _ready() -> void:
	ui.hide()
	start_bounce()


func start_bounce():
	tween = create_tween()
	tween.tween_property(label_3d, "position:y", -0.3, 1)
	tween.tween_property(label_3d, "position:y", 0.0, 1)
	tween.set_loops()


func stop_bounce():
	if tween:
		tween.kill()
	label_3d.position.y = 0


func _on_interaction_component_3d_interacted_with(
	_player: SpiritkeeperCharacterController3D
) -> void:
	stop_bounce()
	ui.show()


func _on_quit_pressed() -> void:
	ui.hide()
	EventBus.stop_player_interaction.emit()
