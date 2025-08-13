class_name WindPlatformerMinigameUpgradeLogic
extends BaseMinigameUpgradeLogic

enum Type { MOVE_SPEED, AIR_CONTROL, DIVE, JUMP_HEIGHT, MORE_CLOUDS, BONUS2X, BONUS5X }

@export var type: Type


func _apply_effect(game: BaseMinigame, upgrade: MinigameUpgrade):
	var my_game: WindPlatformerMinigame = game

	match type:
		Type.MOVE_SPEED:
			my_game.player.move_speed_factor = 1 + upgrade.get_current_effect_modifier()
		Type.AIR_CONTROL:
			my_game.player.air_control_bonus = upgrade.get_current_effect_modifier()
		Type.DIVE:
			my_game.player.dive_control = upgrade.get_current_effect_modifier()
		Type.JUMP_HEIGHT:
			my_game.player.jump_speed_bonus = upgrade.get_current_effect_modifier()
		Type.MORE_CLOUDS:
			my_game.cloud_spawner.cloud_bonus = upgrade.get_current_effect_modifier()
		Type.BONUS2X:
			my_game.cloud_spawner.multiplier_2x_chance = upgrade.get_current_effect_modifier()
		Type.BONUS5X:
			my_game.cloud_spawner.multiplier_5x_chance = upgrade.get_current_effect_modifier()
