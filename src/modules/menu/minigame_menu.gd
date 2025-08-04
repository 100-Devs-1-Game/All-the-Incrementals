class_name MinigameMenu
extends Control

signal play
signal open_upgrades
signal exit

@export var visible_on_start: bool = true
@export var minigame: BaseMinigame
@export var pause: Pause


func _ready() -> void:
	if visible_on_start:
		pause.pause()
		visible = true
	else:
		visible = false


func open_menu() -> void:
	pause.pause()
	visible = true


func _on_play_pressed() -> void:
	pause.try_unpause()
	visible = false
	play.emit()


func _on_upgrades_pressed() -> void:
	open_upgrades.emit()


func _on_exit_pressed() -> void:
	visible = false
	minigame.visible = false
	pause.try_unpause()
	exit.emit()
	minigame.exit()
