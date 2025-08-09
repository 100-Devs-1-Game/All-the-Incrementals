class_name FireFightersMinigameItemUpgradeLogic
extends BaseMinigameUpgradeLogic

@export var item: FireFightersMinigameItem


func _apply_effect(game: BaseMinigame, upgrade: MinigameUpgrade):
	var my_game: FireFightersMinigame = game
	my_game.item_spawner.add_item(item)
	item.spawn_amount = upgrade.get_current_effect_modifier()
