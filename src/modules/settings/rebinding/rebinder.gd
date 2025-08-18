extends Control

var action_id := 0
var caller: Button
var listening := true
var action_text

@onready var input_label = $Panel/Panel2/Panel/NewKeyLabel
@onready var key_label = $Panel/KeyLabel
@onready var error_label = $Panel/Error

@onready var settings = get_parent()


func _ready() -> void:
	$Cancel.pressed.connect(_exit_rebinder)
	action_text = GameSettings.action_names.get(action_id)["name"]
	key_label.text = "Press any key to rebind " + action_text


func _input(event: InputEvent) -> void:
	if listening and event is InputEventKey and event.is_pressed():
		var old_event = InputMap.action_get_events(action_text)
		var old_key = old_event.get(GameSettings.action_names.get(action_id)["index"])
		input_label.text = event.as_text()
		listening = false
		if GameSettings.rebind_request(action_text, old_key, event, action_id):
			print("That'll do donkeh, that'll do.")
			caller.text = event.as_text()
			await get_tree().create_timer(0.3).timeout
			_exit_rebinder()
		else:
			if error_label:
				error_label.show()
				await get_tree().create_timer(1.0).timeout
				error_label.hide()
				listening = true


func _exit_rebinder():
	settings.status_rebinding = false
	print("Exiting rebinder")
	queue_free()
