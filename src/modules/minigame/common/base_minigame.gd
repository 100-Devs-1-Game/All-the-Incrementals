class_name BaseMinigame
extends Node

@export var data: MinigameData

var score: int


func _ready() -> void:
	if SceneLoader.has_current_minigame():
		push_warning("Detected direct Minigame start")
		if data == null:
			push_error("No MinigameData set")
	else:
		data = SceneLoader.get_current_minigame()

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


func exit() -> void:
	print("Emitting exit_minigame signal")
	EventBus.emit_signal(EventBus.exit_minigame.get_name())
