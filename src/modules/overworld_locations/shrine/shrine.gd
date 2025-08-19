extends Node3D

@export var upgrade_tree_scene: PackedScene

var upgrade_tree: UpgradeTree


func _ready() -> void:
	_debug_force_settlement_data()


func debug_enter_breezekiln() -> void:
	SceneLoader.enter_breezekiln()


func debug_enter_clayport() -> void:
	SceneLoader.enter_clayport()


# For temporary debugging purposes, directly set the current settlement. Once
# we have the overworld code working, we'll be setting the settlement naturally.
func _debug_force_settlement_data() -> void:
	var clayport_data: SettlementData = load("res://modules/overworld_locations/shrine/shrine.tres")
	SceneLoader._current_settlement = clayport_data


func quit_game() -> void:
	get_tree().quit()


func _on_interaction_component_interacted_with(_player: SpiritkeeperCharacterController3D) -> void:
	upgrade_tree = upgrade_tree_scene.instantiate()
	upgrade_tree.closed.connect(on_upgrade_tree_closed)
	add_child(upgrade_tree)


func on_upgrade_tree_closed():
	if not upgrade_tree or not is_instance_valid(upgrade_tree):
		return
	upgrade_tree.queue_free()
	EventBus.stop_player_interaction.emit()
