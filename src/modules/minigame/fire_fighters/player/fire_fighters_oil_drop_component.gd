class_name FireFightersMinigameOilDropComponent
extends Node

signal finished

var _drops_left: int = 0

@onready var player: FireFightersMinigamePlayer = get_parent()


func _ready() -> void:
	player.changed_tile.connect(_on_player_changed_tile)


func queue_oil_drops(n: int):
	_drops_left = n


func _on_player_changed_tile(tile: Vector2i):
	if _drops_left <= 0:
		return
	player.game.add_oil(tile)
	_drops_left -= 1
	if _drops_left == 0:
		finished.emit()
