class_name Settings
extends Control

const REBINDER = preload("res://modules/settings/rebinding/rebinder.tscn")

@export_category("Assignments")
@export_group("Buttons")
@export var low_button: Button
@export var medium_button: Button
@export var high_button: Button
@export var best_button: Button
@export var screen_button: Button
@export var exit_button: Button
@export var restore_button: Button
@export_group("Sliders")
@export var master_slider: Slider
@export var music_slider: Slider
@export var sfx_slider: Slider

var status_rebinding := false
var action_menu := false  #Changes menu for ingame
var fullscreen := false

var ordered_actions := [
	"primary_action",
	"primary_action",
	"secondary_action",
	"secondary_action",
	"right",
	"right",
	"down",
	"down",
	"left",
	"left",
	"up",
	"up",
	"exit_menu",
	"exit_menu"
]

var setting_buttons := {}
var audio_sliders := {}

@onready var quality_label = $Panel/SettingsContainer/MultiContainer/QualityLabel


func _ready() -> void:
	setting_buttons = {
		low_button: "Low",
		medium_button: "Medium",
		high_button: "High",
		best_button: "Best",
		screen_button: "Fullscreen",
		exit_button: "Exit",
		restore_button: "Restore"
	}

	audio_sliders = {master_slider: "Master", music_slider: "Music", sfx_slider: "Sfx"}
	setup()


func setup() -> void:
	if action_menu:
		$CoverBG.queue_free()
	connect_signals()
	update_ui()


func connect_signals() -> void:
	var keybinders = get_tree().get_nodes_in_group("keybind")
	var bind_id := 0

	for button in setting_buttons.keys():
		if not button.is_connected("pressed", _on_button_pressed):
			button.pressed.connect(_on_button_pressed.bind(setting_buttons[button]))
	for slider in audio_sliders.keys():
		if not slider.is_connected("value_changed", _on_volume_changed):
			slider.value_changed.connect(_on_volume_changed.bind(audio_sliders[slider]))

	for key in keybinders:
		bind_id += 1
		key.set_meta("bind_id", bind_id)
		if not key.is_connected("pressed", call_rebinder):
			key.pressed.connect(call_rebinder.bind(bind_id, key))
		var action = ordered_actions[bind_id - 1]
		var index := (bind_id - 1) % 2
		var keycode = GameSettings.keybinds[action][index]
		key.text = OS.get_keycode_string(keycode)


func _input(event: InputEvent) -> void:
	if !status_rebinding:
		if event.is_action_pressed("exit_menu"):
			SceneLoader.enter_main_menu()


func _on_button_pressed(action: String) -> void:
	match action:
		"Low", "Medium", "High", "Best":
			GameSettings.quality = action
		"Fullscreen":
			GameSettings.set_fullscreen(not GameSettings.fullscreen)
		"Exit":
			SceneLoader.enter_main_menu()
		"Restore":
			GameSettings.restore_defaults()
			connect_signals()
	update_ui()
	GameSettings.save_settings()


func _on_volume_changed(value: float, bus_name: String) -> void:
	var linear = clamp(value / 100.0, 0.0, 1.0)
	GameSettings.set_audio(bus_name, linear)
	update_ui()
	GameSettings.save_settings()


func call_rebinder(key_id: int, button):
	status_rebinding = true
	print("Calling rebinder.")
	var rebinder = REBINDER.instantiate()
	rebinder.action_id = key_id
	rebinder.caller = button
	add_child(rebinder)


func update_ui() -> void:
	if GameSettings.fullscreen:
		screen_button.text = "Fullscreen: ON"
	else:
		screen_button.text = "Fullscreen: OFF"

	quality_label.text = "3D Quality: " + str(GameSettings.quality)

	master_slider.value = GameSettings.master_volume
	music_slider.value = GameSettings.music_volume
	sfx_slider.value = GameSettings.sfx_volume

	master_slider.get_child(0).text = str(roundi(GameSettings.master_volume), "%")
	music_slider.get_child(0).text = str(roundi(GameSettings.music_volume), "%")
	sfx_slider.get_child(0).text = str(roundi(GameSettings.sfx_volume), "%")
