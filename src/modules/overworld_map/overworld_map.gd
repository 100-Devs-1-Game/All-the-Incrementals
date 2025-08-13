class_name OverworldMapMenu extends Control

const BREEZEKILN_DATA := preload("res://modules/overworld_locations/breezekiln/breezekiln.tres")
const CLAYPORT_DATA := preload("res://modules/overworld_locations/clayport/clayport.tres")
const SHRINE_DATA := preload("res://modules/overworld_locations/shrine/shrine.tres")

@onready var breezekiln_button: Button = %Breezekiln
@onready var clayport_button: Button = %Clayport
@onready var shrine_button: Button = %Shrine


func _ready() -> void:
	hide()

	breezekiln_button.button_up.connect(
		func():
			EventBus.wants_to_travel_to.emit(BREEZEKILN_DATA)
			hide()
	)
	clayport_button.button_up.connect(
		func():
			EventBus.wants_to_travel_to.emit(CLAYPORT_DATA)
			hide()
	)
	shrine_button.button_up.connect(
		func():
			EventBus.wants_to_travel_to.emit(SHRINE_DATA)
			hide()
	)
