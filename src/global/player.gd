extends Node

var data: PlayerState


func _init():
	EventBus.game_loaded.connect(func(world_state: WorldState): data = world_state.player_state)


func add_stack_to_inventory(stack: EssenceStack):
	if not data:
		push_error("Player data not set")
		return
	data.inventory.add_stack(stack)
	SaveGameManager.save()


func can_afford(_cost: EssenceInventory) -> bool:
	if not data:
		push_error("Player data not set")
		# assuming this is a test session
		return true
	return false
	# TODO not implemented yet
	#
	#return data.inventory.has_all(cost)
