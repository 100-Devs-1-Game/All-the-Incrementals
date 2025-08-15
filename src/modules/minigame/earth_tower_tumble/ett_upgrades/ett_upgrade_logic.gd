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
