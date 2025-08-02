class_name FireFightersMinigameItemUpgradeLogic
extends FireFightersMinigameUpgradeLogic

@export var item: FireFightersMinigameItem


func _apply_effect(game: BaseMinigame, upgrade: MinigameUpgrade):
	var my_game: FireFightersMinigame = game
	my_game.item_spawner.add_available(item)
	item.set_probability_level(upgrade.get_level())
