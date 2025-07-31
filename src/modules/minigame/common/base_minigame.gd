class_name BaseMinigame
extends Node

var data: MinigameData

var score: int


func _ready() -> void:
	assert(SceneLoader.current_minigame != null)
	data = SceneLoader.current_minigame

	open_menu()


# virtual function for initializing the Minigame
func _initialize():
	pass


# virtual function for starting the Minigame
func _start():
	pass


func open_menu():
	# TODO
	#
	# trigger start button manually while there's no menu implemented
	on_start_button_pressed()


func on_start_button_pressed():
	_initialize()
	_start()


func add_score(n: int = 1):
	score += n


func game_over():
	#TODO
	pass
