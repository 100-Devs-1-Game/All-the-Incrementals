class_name MinigameMenu
extends Control

signal play
signal open_upgrades
signal exit

@export var minigame: BaseMinigame


func _ready() -> void:
	get_tree().paused = true
	visible = true


func _on_play_pressed() -> void:
	get_tree().paused = false
	visible = false
	play.emit()


func _on_upgrades_pressed() -> void:
	open_upgrades.emit()


func _on_exit_pressed() -> void:
	visible = false
	minigame.visible = false
	get_tree().paused = false
	exit.emit()
	minigame.exit()
