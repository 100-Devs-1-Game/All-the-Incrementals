class_name EphUpgradeLogic
extends BaseMinigameUpgradeLogic

enum UpgradeType {
	SPIRIT_KEEPER_BRIGHTNESS,
	SPIRIT_KEEPER_SPEED,
	DESTROY_DASHING_SPIRITS,
	DESTROY_EVIL_SPIRITS,
	POTATO_GROWTH_SPEED,
	NUTRITIOUS_POTATO,
	MORE_POTATOES,
	SLOWER_SPIRITS,
	LESS_DASHING_SPIRITS,
	LESS_EVIL_SPIRITS,
}

@export var upgrade_type: UpgradeType

var upgrade_type_to_signal: Dictionary[UpgradeType, String] = {
	UpgradeType.SPIRIT_KEEPER_BRIGHTNESS: "spirit_keeper_brightness",
	UpgradeType.SPIRIT_KEEPER_SPEED: "spirit_keeper_speed",
	UpgradeType.DESTROY_DASHING_SPIRITS: "destroy_dashing_spirits",
	UpgradeType.DESTROY_EVIL_SPIRITS: "destroy_evil_spirits",
	UpgradeType.POTATO_GROWTH_SPEED: "potato_growth_speed",
	UpgradeType.NUTRITIOUS_POTATO: "nutritious_potato",
	UpgradeType.MORE_POTATOES: "more_potatoes",
	UpgradeType.SLOWER_SPIRITS: "slower_spirits",
	UpgradeType.LESS_DASHING_SPIRITS: "less_dashing_spirits",
	UpgradeType.LESS_EVIL_SPIRITS: "less_dashing_spirits",
}


func _apply_effect(p_game: BaseMinigame, upgrade: MinigameUpgrade):
	var game: EarthPotatoHerdingMinigame = p_game
	if upgrade.unlocks_feature:
		game.emit_signal(upgrade_type_to_signal[upgrade_type], true)
	else:
		game.emit_signal(
			upgrade_type_to_signal[upgrade_type], upgrade.get_current_effect_modifier()
		)
