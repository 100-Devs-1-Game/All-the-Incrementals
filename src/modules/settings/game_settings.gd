extends Node

#Setting data for saving,loading and resetting settings to default. Stores data.

# Buttons for rebinding
var keybinds := {
	"primary_action": [KEY_SPACE, KEY_Z],
	"secondary_action": [KEY_E, KEY_X],
	"right": [KEY_D, KEY_RIGHT],
	"down": [KEY_S, KEY_DOWN],
	"left": [KEY_A, KEY_LEFT],
	"up": [KEY_W, KEY_UP],
	"exit_menu": [KEY_ESCAPE, KEY_C],
}

var action_names := {
	1: {"name": "primary_action", "index": 0},  #Primary, 1st key
	2: {"name": "primary_action", "index": 1},  #Primary, 2nd key
	3: {"name": "secondary_action", "index": 0},  #Secondary, 1st key
	4: {"name": "secondary_action", "index": 1},  #Secondary, 2nd key and so on
	5: {"name": "right", "index": 0},
	6: {"name": "right", "index": 1},
	7: {"name": "down", "index": 0},
	8: {"name": "down", "index": 1},
	9: {"name": "left", "index": 0},
	10: {"name": "left", "index": 1},
	11: {"name": "up", "index": 0},
	12: {"name": "up", "index": 1},
	13: {"name": "exit_menu", "index": 0},
	14: {"name": "exit_menu", "index": 1}
}

# Video Settings
var fullscreen: bool = false
var quality: String = "Best"  #Low, Medium, High, Best

# Audio Settings
var master_volume: float = 50.0
var music_volume: float = 50.0
var sfx_volume: float = 50.0
var save_path = "user://settings.cfg"
var audio_players: Array = []
var active_audio: bool = false


func _ready() -> void:
	load_settings()

func set_audio(bus: int, volume: float):
	match bus:
		0:
			master_volume = volume * 100.0
		1:
			music_volume = volume * 100.0
		2:
			sfx_volume = volume * 100.0
	AudioServer.set_bus_volume_db(bus, volume)
	print("Audio adjusted: ", bus, volume)

## Creates an audio node and plays the given audio globally
func create_global_audio(audio: AudioStream, bus: String): #0 is master, 1 is Music, 2 is SFX
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)

	audio_player.bus = bus
	audio_player.stream = audio
	audio_player.play()

	audio_players.append(audio_player)
	
	if !active_audio:
		active_audio = true
		check_audio_players()

func check_audio_players():
	while active_audio:
		for i in range(audio_players.size() -1, -1, -1):
			var a: AudioStreamPlayer = audio_players[i]
			if !a.is_playing():
				a.queue_free()
				audio_players.remove_at(i)

		if audio_players.is_empty():
			active_audio = false
			break
	
	await get_tree().create_timer(0.2).timeout

func set_fullscreen(state: bool) -> void:
	fullscreen = state
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


## Saves current setting configurations to user://settings.cfg
func save_settings():
	var config = ConfigFile.new()
	config.set_value("video", "fullscreen", fullscreen)
	config.set_value("video", "quality", quality)

	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)

	var str_keybinds := {}
	for key in keybinds:
		str_keybinds[key] = []
		for keycode in keybinds[key]:
			str_keybinds[key].append(OS.get_keycode_string(keycode))

	config.set_value("controls", "keybinds", str_keybinds)

	var err := config.save(save_path)
	if err == OK:
		print("Settings saved to: ", save_path)
	else:
		print("Error, settings failed to save.")


## Loads previous setting configurations from usser://settings.cfg
func load_settings():
	var config = ConfigFile.new()
	var err := config.load(save_path)

	if err != OK:
		print("No previous save found.")
		return

	fullscreen = config.get_value("video", "fullscreen", fullscreen)
	quality = config.get_value("video", "quality", quality)

	master_volume = config.get_value("audio", "master_volume", master_volume)
	music_volume = config.get_value("audio", "music_volume", music_volume)
	sfx_volume = config.get_value("audio", "sfx_volume", sfx_volume)

	var saved_binds = config.get_value("controls", "keybinds", keybinds)
	keybinds.clear()

	for key in saved_binds:
		keybinds[key] = []
		for key_name in saved_binds[key]:
			keybinds[key].append(OS.find_keycode_from_string(key_name))


## Sets settings back to the defaults then saves them to file automatically
func restore_defaults():
	fullscreen = false
	quality = "Best"
	master_volume = 50.0
	music_volume = 50.0
	sfx_volume = 50.0
	keybinds = {
		"primary_action": [KEY_SPACE, KEY_Z],
		"secondary_action": [KEY_E, KEY_X],
		"right": [KEY_D, KEY_RIGHT],
		"down": [KEY_S, KEY_DOWN],
		"left": [KEY_A, KEY_LEFT],
		"up": [KEY_W, KEY_UP],
		"exit_menu": [KEY_ESCAPE, KEY_C]
	}
	#apply_new_inputmap()
	save_settings()


## Requests a keybind change from an old key to a new one
func rebind_request(
	action: String, old_key: InputEventKey, new_key: InputEventKey, action_id
) -> bool:
	var success := true
	var new_keycode = new_key.keycode
	print(
		"Request recieved: ", action, " to remove ", old_key.as_text(), " for ", new_key.as_text()
	)
	for bind_list in keybinds.values():
		if new_keycode in bind_list:
			print("This key is already in use by another action you peasant >:(")
			return false

	InputMap.action_erase_event(action, old_key)
	InputMap.action_add_event(action, new_key)
	var index = action_names[action_id]["index"]
	keybinds[action][index] = new_key.keycode
	save_settings()
	return success


## Applies the default keybinds
func apply_new_inputmap():
	for action in keybinds:
		for event in InputMap.action_get_events(action):
			InputMap.action_erase_event(action, event)
		for keycode in keybinds[action]:
			var ev := InputEventKey.new()
			ev.keycode = keycode
			InputMap.action_add_event(action, ev)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_settings()
