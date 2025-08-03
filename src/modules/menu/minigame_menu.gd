class_name MinigameMenu
extends Control

signal play
signal open_upgrades
signal exit


func _on_play_pressed() -> void:
	play.emit()


func _on_upgrades_pressed() -> void:
	open_upgrades.emit()


func _on_exit_pressed() -> void:
	exit.emit()
