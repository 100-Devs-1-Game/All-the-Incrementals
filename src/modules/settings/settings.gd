extends Control

@onready var setting_buttons := {
	$Panel/SettingsContainer/QualityContainer/LowQualityButton: "Low",
	$Panel/SettingsContainer/QualityContainer/MedQualityButton: "Medium",
	$Panel/SettingsContainer/QualityContainer/HighQualityButton: "High",
	$Panel/SettingsContainer/QualityContainer/BestQualityButton: "Best",
	$Panel/SettingsContainer/ScreenButton: "Fullscreen",
	$BackButton: "Exit"
}

@onready var audio_sliders := {
	$Panel/SettingsContainer/MasterContainer/MasterSlider: "Master",
	$Panel/SettingsContainer/MusicContainer/MusicSlider: "Music",
	$Panel/SettingsContainer/SFXContainer/SFXSlider: "SFX"
}

var fullscreen := false
var quality := "Best"
var sfx_volume := 50.0
var music_volume := 50.0
var master_volume := 50.0

const REBINDER = preload("res://modules/settings/rebinding/rebinder.tscn")

func _ready() -> void:
	var keybinders = get_tree().get_nodes_in_group("keybind")
	var bind_id := 0

	# Flatten keybinds into an array in a fixed order
	var ordered_actions := [
		"primary_action", "primary_action",
		"secondary_action", "secondary_action",
		"right", "right",
		"down", "down",
		"left", "left",
		"up", "up",
		"exit_menu", "exit_menu"
	]
	
	await get_tree().process_frame
	for button in setting_buttons.keys():
		button.pressed.connect(_on_button_pressed.bind(setting_buttons[button]))
	for slider in audio_sliders.keys():
		slider.value_changed.connect(_on_volume_changed.bind(audio_sliders[slider]))
	for button in keybinders:
		bind_id += 1
		button.set_meta("bind_id", bind_id)
		button.pressed.connect(_call_rebinder.bind(bind_id, button))
	
		# Figure out which action + index to display
		var action = ordered_actions[bind_id - 1]
		var index := (bind_id - 1) % 2
		var keycode = SettingsRetainer.keybinds[action][index]
	
		# Set the button text to the readable key name
		button.text = OS.get_keycode_string(keycode)

	get_settings()
	update_ui()

## Creates and adds the REBINDER scene and provide it with information about which key to change.
func _call_rebinder(key_id: int, button):
	print("This keys bind_id is: ", key_id)
	var rebinder = REBINDER.instantiate()
	rebinder.action_id = key_id
	rebinder.caller = button
	add_child(rebinder)

func _on_button_pressed(action: String) -> void:
	match action:
		"Low", "Medium", "High", "Best":
			_set_quality(action)
			print("Game 3D Quality set to: ", quality)
		"Fullscreen":
			fullscreen = !fullscreen
			
			print("Game fullscreen: ", fullscreen)
		"Exit":
			apply_changes()
			get_tree().change_scene_to_packed(load("res://modules/menu/main_menu.tscn"))

func _on_volume_changed(value: float, type: String) -> void:
	print("Changed ", type, " volume to ", value)
	var balance = clamp(value / 100.0, 0.001, 1.0)
	match type:
		"Master":
			master_volume = value
			AudioServer.set_bus_volume_db(0, linear_to_db(balance))
			$Panel/SettingsContainer/MasterContainer/MasterSlider/ValueLabel.text = str(roundi(value))
		"Music":
			music_volume = value
			AudioServer.set_bus_volume_db(1, linear_to_db(balance))
			$Panel/SettingsContainer/MusicContainer/MusicSlider/ValueLabel.text = str(roundi(value))
		"SFX":
			sfx_volume = value
			AudioServer.set_bus_volume_db(2, linear_to_db(balance))
			$Panel/SettingsContainer/SFXContainer/SFXSlider/ValueLabel.text = str(roundi(value))

func _set_quality(level: String):
	print("Setting quality to:", level)
	quality = level

func _fullscreen_window(boolean: bool):
	fullscreen = boolean
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_action", false):
		print("Primary action done")

func get_settings():
	fullscreen = SettingsRetainer.fullscreen
	quality = SettingsRetainer.quality
	master_volume = SettingsRetainer.master_volume
	sfx_volume = SettingsRetainer.sfx_volume
	music_volume = SettingsRetainer.music_volume

func update_ui():
	$Panel/SettingsContainer/MasterContainer/MasterSlider.value = master_volume
	$Panel/SettingsContainer/SFXContainer/SFXSlider.value = sfx_volume
	$Panel/SettingsContainer/MusicContainer/MusicSlider.value = music_volume
	$Panel/SettingsContainer/ScreenButton.text = "Fullscreen: " + str(fullscreen)

func apply_changes():
	print("Settings applied")
	SettingsRetainer.fullscreen = fullscreen
	SettingsRetainer.quality = quality
	SettingsRetainer.master_volume = master_volume
	SettingsRetainer.sfx_volume = sfx_volume
	SettingsRetainer.music_volume = music_volume
