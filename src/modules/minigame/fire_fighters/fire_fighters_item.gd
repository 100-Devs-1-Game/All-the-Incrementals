class_name FireFightersMinigameItem
extends Resource

enum Type { PICKUP, OBJECT }

@export var name: String
@export var type: Type
@export var icon: Texture2D

var spawn_probability: float = 1.0


func _on_burn(_game: FireFightersMinigame, _item: FireFightersMinigameItemInstance):
	pass


func _on_use(_player: FireFightersMinigamePlayer):
	pass


func _on_new_tile(_player: FireFightersMinigamePlayer, _item: FireFightersMinigameItemInstance):
	pass


func _on_destroy(_game: FireFightersMinigame, item: FireFightersMinigameItemInstance):
	item.queue_free()


func _on_pick_up(_player: FireFightersMinigamePlayer):
	pass
