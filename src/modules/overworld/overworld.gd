class_name OverworldScene extends Node

const PLAYER_CHARACTER_SCENE = preload(
	"res://modules/overworld_character_controller/spiritkeeper_character_controller_3d.tscn"
)

@export var starting_settlement_data: SettlementData

var _current_settlement: OverworldLocation3D
var _current_settlement_data: SettlementData

@onready var overworld_map: OverworldMapMenu = %OverworldMap
@onready var player_holder_node: Node3D = %PlayerHolder
@onready var settlement_scene_holder_node: Node3D = %SceneHolder
@onready var journal_page_ui: JournalPageUI = %JournalPageUI


func _ready() -> void:
	assert(is_instance_valid(overworld_map), "OverworldMap node must be set.")
	assert(is_instance_valid(starting_settlement_data), "Starting settlement data must be set.")

	EventBus.wants_to_travel_to.connect(change_to_settlement)
	EventBus.request_journal_page_display.connect(_on_display_journal_page)

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

	# to appease GuT tests
	if not SaveGameManager.world_state:
		SaveGameManager.start_game()

	var new_settlement = data.settlement_scene.instantiate()
	assert(new_settlement is OverworldLocation3D)
	settlement_scene_holder_node.add_child(new_settlement)

	#TODO: Figure out context of where the player is coming from (other settlement/minigame),
	#and change their position accordingly.

	_current_settlement = new_settlement
	_current_settlement_data = data

	print("Settlement: ", data.display_name, " loaded.")

	var player: SpiritkeeperCharacterController3D = PLAYER_CHARACTER_SCENE.instantiate()
	player.transform = _current_settlement.character_spawner.global_transform
	player_holder_node.add_child(player)


func _on_display_journal_page(data: JournalEntryData):
	journal_page_ui.open(data)
