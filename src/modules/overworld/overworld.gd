class_name OverworldScene extends Node

@export var starting_settlement_data: SettlementData

var _current_settlement: Node
var _current_settlement_data: SettlementData

@onready var overworld_map: OverworldMapMenu = %OverworldMap
@onready var player_holder_node: Node3D = %PlayerHolder
@onready var settlement_scene_holder_node: Node3D = %SceneHolder


func _ready() -> void:
	assert(is_instance_valid(overworld_map), "OverworldMap node must be set.")
	assert(is_instance_valid(starting_settlement_data), "Starting settlement data must be set.")

	EventBus.wants_to_travel_to.connect(change_to_settlement)

	# Runs when we started somewhere else
	if SceneLoader.get_current_settlement_data():
		change_to_settlement(SceneLoader.get_current_settlement_data())
	else:  # Runs when we start on the overworld scene directly
		change_to_settlement(starting_settlement_data)


func open_overworld_map() -> void:
	overworld_map.show()


func change_to_settlement(data: SettlementData) -> void:
	print("Changing to: ", data.display_name)
	if is_instance_valid(_current_settlement):
		_current_settlement.queue_free()

	var new_settlement = data.settlement_scene.instantiate()
	settlement_scene_holder_node.add_child(new_settlement)

	#TODO: Figure out context of where the player is coming from (other settlement/minigame),
	#and change their position accordingly.

	_current_settlement = new_settlement
	_current_settlement_data = data

	print("Settlement: ", data.display_name, " loaded.")

	var exits := get_tree().get_nodes_in_group(SettlementExit.SETTLEMENT_EXIT_GROUP)
	for exit in exits:
		exit = exit as SettlementExit
		if not exit.exited_settlement.is_connected(open_overworld_map):
			exit.exited_settlement.connect(open_overworld_map)
			print("Exit (", exit, ") connected signal to overworld map menu")
