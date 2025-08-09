class_name FireFightersMinigameGasCan
extends FireFightersMinigameItem

@export var num_oil_drops: int = 10
@export var explosion_radius: int = 2


func _on_use(player: FireFightersMinigamePlayer):
	player.oil_dropper.queue_oil_drops(num_oil_drops)
	player.oil_dropper.finished.connect(func(): player.unequip_item())


func _on_burn(game: FireFightersMinigame, item: FireFightersMinigameItemInstance):
	game.oil_explosion(game.get_tile_at(item.position), explosion_radius, true)
	item.queue_free()
