class_name WaterRowingRapidsMinigame
extends BaseMinigame


func _init() -> void:
	pass


func _start():
	pass


func _on_rowing_player_spirit_collected(value: int) -> void:
	add_score(value)
