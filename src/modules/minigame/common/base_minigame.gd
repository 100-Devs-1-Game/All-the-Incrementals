class_name BaseMinigame
extends Node

@export var data: MinigameData

var score: int


func add_score(n: int = 1):
	score += n


func game_over():
	#TODO
	pass
