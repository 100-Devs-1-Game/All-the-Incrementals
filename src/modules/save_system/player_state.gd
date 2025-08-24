class_name PlayerState
extends Resource

@export var inventory: EssenceInventory

# Dictionary mapping MinigameData resource path to an array of their latest 5 scores
@export var highscores: Dictionary[StringName, Array]


func get_average_minigame_highscore(minigame: MinigameData) -> float:
	var key: StringName = minigame.resource_path

	if not highscores.has(key):
		return 0

	var all_highscores: Array[int] = highscores[key]

	if all_highscores.is_empty():
		return 0

	var highscore_sum: int = 0
	for highscore in all_highscores:
		highscore_sum += highscore

	var avg_highscore: float = highscore_sum / float(all_highscores.size())

	return avg_highscore
