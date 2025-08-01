extends Control

@onready var input_label = $Panel/Panel/NewKeyLabel
var action_id := 0
var caller: Button
var listening := true


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit_menu"):
		print("Exiting rebinder")
		queue_free()
		return
	if listening and event is InputEventKey and event.is_pressed():
		var action_text = GameSettings.action_names.get(action_id)["name"]
		var old_event = InputMap.action_get_events(action_text)
		var old_key = old_event.get(GameSettings.action_names.get(action_id)["index"])
		input_label.text = event.as_text()
		listening = false
		if GameSettings.rebind_request(action_text, old_key, event, action_id):
			print("That'll do donkeh, that'll do.")
			caller.text = event.as_text()
			await get_tree().create_timer(0.3).timeout
			queue_free()
		else:
			if $Panel/Error:
				$Panel/Error.show()
				await get_tree().create_timer(1.0).timeout
				$Panel/Error.hide()
				listening = true
