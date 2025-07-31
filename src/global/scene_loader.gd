extends Node

var current_minigame: MinigameData


func start_minigame(data: MinigameData):
	current_minigame = data
	get_tree().change_scene_to_packed(data.minigame_scene)


func return_to_overworld():
	# TODO
	pass
