class_name EphUpgradeLogic
extends BaseMinigameUpgradeLogic

enum UpgradeType { NUTRITIOUS_POTATO, SPIRIT_KEEPER_BRIGHTNESS, SPIRIT_KEEPER_SPEED }

@export var upgrade_type: UpgradeType

var upgrade_type_to_signal: Dictionary[UpgradeType, String] = {
	UpgradeType.NUTRITIOUS_POTATO: "nutritious_potato",
	UpgradeType.SPIRIT_KEEPER_BRIGHTNESS: "spirit_keeper_brightness",
	UpgradeType.SPIRIT_KEEPER_SPEED: "spirit_keeper_speed",
}


func _apply_effect(p_game: BaseMinigame, upgrade: MinigameUpgrade):
	var game: EarthPotatoHerdingMinigame = p_game
	game.emit_signal(upgrade_type_to_signal[upgrade_type], upgrade.get_current_effect_modifier())
