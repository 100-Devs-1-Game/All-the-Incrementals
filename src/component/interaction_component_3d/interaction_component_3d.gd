@tool
class_name InteractionComponent3D extends Area3D

signal interacted_with(player: SpiritkeeperCharacterController3D)

@export var object: Node3D
@export var auto_interact: bool = false
@export var action_name: StringName = &"primary_action"

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
	)

	body_exited.connect(
		func(body: Node):
			if body is SpiritkeeperCharacterController3D:
				player = null
	)


func _unhandled_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return

	if not is_instance_valid(player):
		return

	if event.is_action_pressed(action_name):
		do_interact()


func do_interact():
	player.interact_with(object)
	interacted_with.emit(player)
	get_viewport().set_input_as_handled()
