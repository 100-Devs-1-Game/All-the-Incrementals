class_name FireFightersMinigameGasCan
extends FireFightersMinigameItem

@export var num_oil_drops: int = 10


func _on_use(player: FireFightersMinigamePlayer):
	player.oil_dropper.queue_oil_drops(num_oil_drops)
	player.oil_dropper.finished.connect(func(): player.unequip_item())
