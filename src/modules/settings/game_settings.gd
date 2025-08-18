extends Node

const BUS_MASTER := "Master"
const BUS_MUSIC := "Music"
const BUS_SFX := "Sfx"

var keybinds := {
	"primary_action": [KEY_SPACE, KEY_Z],
	"secondary_action": [KEY_E, KEY_C],
	"right": [KEY_D, KEY_RIGHT],
	"down": [KEY_S, KEY_DOWN],
	"left": [KEY_A, KEY_LEFT],
	"up": [KEY_W, KEY_UP],
	"exit_menu": [KEY_ESCAPE, KEY_0],
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

var _bus_idx := {
	BUS_MASTER: 0,
	BUS_MUSIC: -1,
	BUS_SFX: -1,
}


func _ready() -> void:
	load_settings()
	_check_buses()
	_cache_bus()
	_apply_all_audio_to_buses()


func set_audio(bus, volume: float) -> void:
	var idx := -1
	if typeof(bus) == TYPE_INT:
		idx = int(bus)
	else:
		idx = _bus_index(str(bus))

	if idx < 0 or idx >= AudioServer.get_bus_count():
		push_warning("Invalid audio bus: %s" % [str(bus)])
		return

	# Keep UI state in 0–100 %, but apply to AudioServer in dB
	if idx == _bus_index(BUS_MASTER):
		master_volume = clamp(volume * 100.0, 0.0, 100.0)
	elif idx == _bus_index(BUS_MUSIC):
		music_volume = clamp(volume * 100.0, 0.0, 100.0)
	elif idx == _bus_index(BUS_SFX):
		sfx_volume = clamp(volume * 100.0, 0.0, 100.0)

	if volume <= 0.0001:
		AudioServer.set_bus_mute(idx, true)
		AudioServer.set_bus_volume_db(idx, -80.0)
	else:
		AudioServer.set_bus_mute(idx, false)
		AudioServer.set_bus_volume_db(idx, linear_to_db(volume))


## Creates an audio node and plays the given audio globally
func create_global_audio(audio: AudioStream, bus: String) -> void:
	var audio_player := AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.bus = bus
	audio_player.stream = audio
	audio_player.play()
	audio_players.append(audio_player)

	if not active_audio:
		active_audio = true
		check_audio_players()


func check_audio_players() -> void:
	while active_audio:
		for i in range(audio_players.size() - 1, -1, -1):
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


func save_settings() -> void:
	print("Saving")
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


func load_settings() -> void:
	var config := ConfigFile.new()
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


func restore_defaults() -> void:
	fullscreen = false
	quality = "Best"
	master_volume = 30.0
	music_volume = 30.0
	sfx_volume = 30.0
	keybinds = {
		"primary_action": [KEY_SPACE, KEY_Z],
		"secondary_action": [KEY_E, KEY_X],
		"right": [KEY_D, KEY_RIGHT],
		"down": [KEY_S, KEY_DOWN],
		"left": [KEY_A, KEY_LEFT],
		"up": [KEY_W, KEY_UP],
		"exit_menu": [KEY_ESCAPE, KEY_C]
	}
	save_settings()
	_apply_all_audio_to_buses()


func rebind_request(
	action: String, old_key: InputEventKey, new_key: InputEventKey, action_id
) -> bool:
	var new_keycode := new_key.keycode
	for bind_list in keybinds.values():
		if new_keycode in bind_list:
			print("This key is already in use by another action!")
			return false
	InputMap.action_erase_event(action, old_key)
	InputMap.action_add_event(action, new_key)
	var index = action_names[action_id]["index"]
	keybinds[action][index] = new_key.keycode
	save_settings()
	return true


func apply_new_inputmap() -> void:
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


func _apply_all_audio_to_buses() -> void:
	set_audio(BUS_MASTER, clamp(master_volume / 100.0, 0.0, 1.0))
	set_audio(BUS_MUSIC, clamp(music_volume / 100.0, 0.0, 1.0))
	set_audio(BUS_SFX, clamp(sfx_volume / 100.0, 0.0, 1.0))


func _cache_bus() -> void:
	_bus_idx[BUS_MASTER] = AudioServer.get_bus_index(BUS_MASTER)
	_bus_idx[BUS_MUSIC] = AudioServer.get_bus_index(BUS_MUSIC)
	_bus_idx[BUS_SFX] = AudioServer.get_bus_index(BUS_SFX)


func _bus_index(bus_name: String) -> int:
	var idx := -1
	if _bus_idx.has(bus_name):
		idx = int(_bus_idx[bus_name])
	if idx == -1:
		idx = AudioServer.get_bus_index(bus_name)
		if idx != -1:
			_bus_idx[bus_name] = idx
	return idx


func _check_buses() -> void:
	var master_idx := AudioServer.get_bus_index(BUS_MASTER)
	if master_idx == -1 and AudioServer.get_bus_count() == 0:
		AudioServer.add_bus(0)
		AudioServer.set_bus_name(0, BUS_MASTER)

	# Music
	if AudioServer.get_bus_index(BUS_MUSIC) == -1:
		AudioServer.add_bus(AudioServer.get_bus_count())
		var new_idx := AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(new_idx, BUS_MUSIC)
		AudioServer.set_bus_send(new_idx, BUS_MASTER)

	# Sfx
	if AudioServer.get_bus_index(BUS_SFX) == -1:
		AudioServer.add_bus(AudioServer.get_bus_count())
		var new_idx2 := AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(new_idx2, BUS_SFX)
		AudioServer.set_bus_send(new_idx2, BUS_MASTER)
