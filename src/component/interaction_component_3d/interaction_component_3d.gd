@tool
class_name InteractionComponent3D extends Area3D

signal interacted_with(player: SpiritkeeperCharacterController3D)

@export var object: Node3D
@export var auto_interact: bool = false
@export var action_name: StringName = &"primary_action"

## It will show after "Press SPACE to" when the player is in range
@export var action_ui_suffix: String = ""

@export var initial_sound: AudioStream
@export var finishing_sound: AudioStream

var player: SpiritkeeperCharacterController3D = null


func _enter_tree() -> void:
	monitorable = false

	set_collision_layer_value(1, false)
	set_collision_mask_value(1, true)


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	if not object:
		object = get_parent()
	assert(object != null)

	body_entered.connect(
		func(body: Node):
			if body is SpiritkeeperCharacterController3D:
				player = body
				if auto_interact:
					do_interact()
					player = null
				else:
					EventBus.notify_player_possible_interaction.emit(self)
	)

	body_exited.connect(
		func(body: Node):
			if body is SpiritkeeperCharacterController3D:
				player = null
				EventBus.notify_player_interaction_lost.emit(self)
	)


func _unhandled_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return

	if not is_instance_valid(player):
		return

	if player.is_interacting():
		return

	if event.is_action_pressed(action_name):
		do_interact()


func do_interact():
	assert(player != null)
	if not player.interact_with(object):
		return
	player.set_interaction_sounds(initial_sound, finishing_sound)
	get_viewport().set_input_as_handled()
	interacted_with.emit(player)
