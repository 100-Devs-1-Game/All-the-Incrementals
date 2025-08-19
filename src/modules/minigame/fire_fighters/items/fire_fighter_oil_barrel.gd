class_name FireFightersMinigameOilBarrel
extends FireFightersMinigameItem

@export var spill_radius: int = 4
@export var break_sound: AudioStream


func _on_burn(game: FireFightersMinigame, item: FireFightersMinigameItemInstance):
	game.oil_explosion(game.get_tile_at(item.position), spill_radius, true)
	item.queue_free()


func _on_destroy(game: FireFightersMinigame, item: FireFightersMinigameItemInstance):
	game.oil_explosion(game.get_tile_at(item.position), spill_radius, false)
	game.play_audio_effect(break_sound, item.position)
	item.queue_free()
