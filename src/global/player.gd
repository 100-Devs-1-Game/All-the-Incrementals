extends Node

const MAX_HIGH_SCORES_STORED = 5

var data: PlayerState


func _init():
	EventBus.game_loaded.connect(func(world_state: WorldState): data = world_state.player_state)


func add_stack_to_inventory(stack: EssenceStack) -> void:
	if not data:
		push_error("Player data not set")
		return
	data.inventory.add_stack(stack)
	SaveGameManager.save()


func pay_upgrade_cost(cost: EssenceInventory) -> void:
	if not data:
		push_error("Player data not set")
		return
	data.inventory.sub_inventory(cost)
	SaveGameManager.save()


func can_afford(cost: EssenceInventory) -> bool:
	if not data:
		push_error("Player data not set")
		# assuming this is a test session
		return true
	return data.inventory.has_inventory(cost)


func get_highscores(minigame_key: StringName) -> Array[int]:
	var minigame_highscores: Array[int]
	minigame_highscores.assign(data.highscores.get_or_add(minigame_key, []))
	return minigame_highscores


func update_highscores(minigame_key: StringName, score: int) -> void:
	if not data:
		push_error("Player data not set")
		# assuming this is a test session
		return
	var minigame_highscores: Array[int] = get_highscores(minigame_key)
	if minigame_highscores.size() < MAX_HIGH_SCORES_STORED:
		minigame_highscores.append(score)
	elif minigame_highscores.min() < score:
		# We know our arrays are always sorted ascending so can remove from the beginning
		minigame_highscores.pop_front()
		minigame_highscores.append(score)
	minigame_highscores.sort()
	data.highscores[minigame_key] = minigame_highscores
	SaveGameManager.save()
