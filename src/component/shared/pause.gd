class_name Pause
extends Node

var _pause_stack: int = 0  # number of times paused was issued


func pause() -> void:
	_pause_stack += 1
	#print("pause stack: " + str(_pause_stack))
	get_tree().paused = true


func try_unpause() -> void:
	_pause_stack = max(0, _pause_stack - 1)
	#print("pause stack: " + str(_pause_stack))
	if _pause_stack <= 0:
		get_tree().paused = false
