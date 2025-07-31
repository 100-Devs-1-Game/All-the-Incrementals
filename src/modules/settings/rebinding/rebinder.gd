extends Control

var action_id := 0
var action_text := "[Action]"
var action_names := {
	1: {"name": "primary_action", "index": 0},
	2: {"name": "primary_action", "index": 1},
	3: {"name": "secondary_action", "index": 0},
	4: {"name": "secondary_action", "index": 1},
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
var listening := true
var old_events
var old_action
var pos
var caller
var settings

func _ready() -> void:
	_check_action_id(action_id)
	print("Called by ", caller)
	settings = get_parent()

func _check_action_id(id: int):
	#print(action_names.get(action_id))
	action_text = action_names.get(action_id)["name"]
	$Panel/KeyLabel.text = "Press any key to rebind " + str(action_names.get(action_id)["name"])
	old_events = InputMap.action_get_events(action_text)
	pos = action_names.get(action_id)["index"]
	print("THis IS THE INDEX: ", pos)
	old_action = old_events.get(action_names.get(action_id)["index"])
	print("this: ", old_events.get(action_names.get(action_id)["index"]))
	InputMap.action_erase_event(action_text, old_events.get(action_names.get(action_id)["index"]))

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit_menu"):
		print("Rebinding cancelled")
		queue_free()
		return
	if listening and event is InputEventKey and event.is_pressed():
		print("Rebinding key to: ", event.as_text())
		$Panel/Panel/NewKeyLabel.text = event.as_text()
		listening = false
		rebind_key(action_text, old_action, event)

func rebind_key(action: String, old_event: InputEventKey, new_event: InputEventKey) -> void:
	InputMap.action_erase_event(action, old_event)
	InputMap.action_add_event(action, new_event)
	print("Rebound ", action, " to ", new_event.as_text())
	var index = action_names[action_id]["index"]
	SettingsRetainer.keybinds[action][index] = new_event.keycode
	print("Updated SettingsRetainer.keybinds: ", SettingsRetainer.keybinds)
	caller.text = new_event.as_text()
	queue_free()
