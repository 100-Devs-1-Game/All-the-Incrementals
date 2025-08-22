class_name WindRhythmUpgradeLogic
extends BaseMinigameUpgradeLogic

enum UpgradeType {
	CONCENTRATION_DRAIN_RATE,
	CONCENTRATION_MAX_MULTIPLER,
	COMBO_MULT_ADD,
	COMBO_PROTECTION,
	PERFECT_PLAY_BONUS
}

@export var upgrade_type: UpgradeType


func _apply_effect(game: BaseMinigame, upgrade: MinigameUpgrade):
	var my_game: RhythmGame = game

	match upgrade_type:
		UpgradeType.CONCENTRATION_DRAIN_RATE:
			my_game.drain_speed_mult = 1 - upgrade.get_current_effect_modifier()
		UpgradeType.CONCENTRATION_DRAIN_RATE:
			my_game.concentration_max_mult = upgrade.get_current_effect_modifier()
		UpgradeType.COMBO_MULT_ADD:
			my_game.combo_add = upgrade.get_current_effect_modifier()
		UpgradeType.COMBO_PROTECTION:
			my_game.combo_protection_level = upgrade.get_current_effect_modifier()
		UpgradeType.PERFECT_PLAY_BONUS:
			my_game.perfect_play_bonus = upgrade.get_current_effect_modifier()
