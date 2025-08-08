extends Node

const MAX_HIGH_SCORES_STORED = 5

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


func get_highscores(minigame: BaseMinigame) -> Array[int]:
	var minigame_uid = ResourceLoader.get_resource_uid(minigame.data.resource_path)
	var minigame_highscores: Array[int]
	minigame_highscores.assign(data.highscores.get_or_add(minigame_uid, []))
	return minigame_highscores


func update_highscores(minigame: BaseMinigame, score: int) -> void:
	if not data:
		push_error("Player data not set")
		# assuming this is a test session
		return
	var minigame_highscores: Array[int] = get_highscores(minigame)
	if minigame_highscores.size() < MAX_HIGH_SCORES_STORED:
		minigame_highscores.append(score)
	elif minigame_highscores.min() < score:
		# We know our arrays are always sorted ascending so can remove from the beginning
		minigame_highscores.pop_front()
		minigame_highscores.append(score)
	minigame_highscores.sort()
	var minigame_uid = ResourceLoader.get_resource_uid(minigame.data.resource_path)
	data.highscores[minigame_uid] = minigame_highscores
	SaveGameManager.save()
