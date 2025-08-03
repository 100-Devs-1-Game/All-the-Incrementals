extends Control

const REBINDER = preload("res://modules/settings/rebinding/rebinder.tscn")

var action_menu := false #Enable to change Apply&Exit behaviour to queue_free instead of scene change
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

@onready var setting_buttons := {
	$Panel/SettingsContainer/MultiContainer/HBoxContainer/Low: "Low",
	$Panel/SettingsContainer/MultiContainer/HBoxContainer/Medium: "Medium",
	$Panel/SettingsContainer/MultiContainer/HBoxContainer/High: "High",
	$Panel/SettingsContainer/MultiContainer/HBoxContainer/Best: "Best",
	$Panel/SettingsContainer/MultiContainer/FullscreenContainer/ScreenButton: "Fullscreen",
	$BackButton: "Exit",
	$RestoreButton: "Restore"
}

@onready var audio_sliders := {
	$Panel/SettingsContainer/MultiContainer/Masterlbl/MasterSlider: "Master",
	$Panel/SettingsContainer/MultiContainer/Musiclbl/MusicSlider: "Music",
	$Panel/SettingsContainer/MultiContainer/SFXlbl/SFXSlider: "SFX"
}


func _ready() -> void:
	setup()


func setup():
	connect_signals()
	update_ui()


func connect_signals():
	var keybinders = get_tree().get_nodes_in_group("keybind")
	var bind_id := 0
	for button in setting_buttons.keys():
		button.pressed.connect(_on_button_pressed.bind(setting_buttons[button]))
	for slider in audio_sliders.keys():
		slider.value_changed.connect(_on_volume_changed.bind(audio_sliders[slider]))
	for key in keybinders:
		bind_id += 1
		key.set_meta("bind_id", bind_id)
		key.pressed.connect(call_rebinder.bind(bind_id, key))
		var action = ordered_actions[bind_id - 1]
		var index := (bind_id - 1) % 2
		var keycode = GameSettings.keybinds[action][index]
		key.text = OS.get_keycode_string(keycode)


func _on_button_pressed(action: String) -> void:
	update_ui()
	match action:
		"Low", "Medium", "High", "Best":
			GameSettings.quality = action
		"Fullscreen":
			fullscreen = !fullscreen
			print(fullscreen)
			GameSettings.set_fullscreen(fullscreen)
		"Exit":
			if !action_menu:
				get_tree().change_scene_to_packed(load("res://modules/menu/main_menu.tscn"))
			else:
				queue_free()
		"Restore":
			GameSettings.restore_defaults()
			_on_button_pressed("Exit")

func _on_volume_changed(value: float, type: String) -> void:
	var balanced = clamp(value / 100.0, 0.001, 1.0)
	match type:
		"Master":
			GameSettings.set_audio(0, balanced)
		"Music":
			GameSettings.set_audio(1, balanced)
		"SFX":
			GameSettings.set_audio(2, balanced)

	update_ui()


func call_rebinder(key_id: int, button):
	print("Calling rebinder")
	var rebinder = REBINDER.instantiate()
	rebinder.action_id = key_id
	rebinder.caller = button
	add_child(rebinder)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		print("Left key pressed")


func update_ui():
	print(GameSettings.keybinds)
	if GameSettings.fullscreen:
		$Panel/SettingsContainer/MultiContainer/FullscreenContainer/ScreenButton.text = "Fullscreen: " + "ON"
	else:
		$Panel/SettingsContainer/MultiContainer/FullscreenContainer/ScreenButton.text = "Fullscreen: " + "OFF"

	$Panel/SettingsContainer/MultiContainer/QualityLabel.text = (
		"3D Quality: " + str(GameSettings.quality)
	)
	$Panel/SettingsContainer/MultiContainer/Masterlbl/MasterSlider.value = GameSettings.master_volume
	$Panel/SettingsContainer/MultiContainer/Musiclbl/MusicSlider.value = GameSettings.music_volume
	$Panel/SettingsContainer/MultiContainer/SFXlbl/SFXSlider.value = GameSettings.sfx_volume
	$Panel/SettingsContainer/MultiContainer/Masterlbl/MasterSlider/ValueLabel.text = str(
		roundi(GameSettings.master_volume),  "%"
	)
	$Panel/SettingsContainer/MultiContainer/Musiclbl/MusicSlider/ValueLabel.text = str(
		roundi(GameSettings.music_volume), "%"
	)
	$Panel/SettingsContainer/MultiContainer/SFXlbl/SFXSlider/ValueLabel.text = str(
		roundi(GameSettings.sfx_volume), "%"
	)
