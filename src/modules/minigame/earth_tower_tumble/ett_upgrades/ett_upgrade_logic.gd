class_name TumbleTowerUpgradLogic
extends BaseMinigameUpgradeLogic

enum UpgradeType {
	FLIGHT_SPEED,
	BLOCK_AMOUNT,
	MAX_HEIGHT,
	POTATO_CONJURE_SPEED,
	ENEMY_MOVE_SPEED,
	BASE_WIDTH,
	LIVES,
	FROZEN,
	FRIEND,
	MORE_FRIEND,
	BLOCK_POINTS,
}

@export var type: UpgradeType


func _apply_effect(p_game: BaseMinigame, upgrade: MinigameUpgrade):
	var game: EarthTowerTumbleMinigame = p_game

	var effect_modifier: float = upgrade.get_current_effect_modifier()
	print("Current effect modifier: " + str(effect_modifier))

	match type:
		UpgradeType.FLIGHT_SPEED:
			print("Flight speed upgraded")
			game.player_speed_modifier(effect_modifier)
		UpgradeType.POTATO_CONJURE_SPEED:
			print("Conjure upgraded")
			game.player_conjure_modifier(effect_modifier)
		UpgradeType.BASE_WIDTH:
			print("Base width upgraded")
			game.base_width_modifier(effect_modifier)
		UpgradeType.LIVES:
			print("Lives upgraded")
			game.starting_life_modifier(effect_modifier)
		UpgradeType.BLOCK_AMOUNT:
			print("Block amount upgraded")
			game.block_amount_modifier(effect_modifier)
		UpgradeType.ENEMY_MOVE_SPEED:
			print("Enemy speed reduced")
			game.enemy_speed_modifier(effect_modifier)
		UpgradeType.FROZEN:
			print("Chance to have frozen blocks")
		UpgradeType.FRIEND:
			print("You conjur a friend to help")
		UpgradeType.MORE_FRIEND:
			print("You conjure more friends to help")
		UpgradeType.BLOCK_POINTS:
			print("Increase essence per block")
		UpgradeType.MAX_HEIGHT:
			print("Max block height increased")
