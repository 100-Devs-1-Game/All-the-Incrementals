class_name FireFightersMinigameMapFeatureUpgradeLogic
extends BaseMinigameUpgradeLogic

@export var feature: FireFightersMinigameMapFeature


func _apply_effect(game: BaseMinigame, upgrade: MinigameUpgrade):
	var my_game: FireFightersMinigame = game
	my_game.reduce_map_feature_thresholds[feature] = upgrade.get_current_effect_modifier()
