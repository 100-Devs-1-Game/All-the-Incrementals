class_name FireFightersMinigameUpgradeLogic
extends BaseMinigameUpgradeLogic

enum Type { WALK_SPEED, TANK_SIZE, WATER_SPEED, WATER_SPREAD, WATER_ARC_REDUCTION, HITPOINTS }

@export var type: Type


func _apply_effect(game: BaseMinigame, upgrade: MinigameUpgrade):
	var my_game: FireFightersMinigame = game
	match type:
		Type.WALK_SPEED:
			my_game.player.move_speed_factor = upgrade.get_current_effect_modifier() + 1
		Type.TANK_SIZE:
			my_game.player.tank_bonus_size = upgrade.get_current_effect_modifier()
		Type.WATER_SPEED:
			my_game.player.water_speed_factor = upgrade.get_current_effect_modifier() + 1
		Type.WATER_SPREAD:
			my_game.player.water_spread_factor = upgrade.get_current_effect_modifier() + 1
		Type.WATER_ARC_REDUCTION:
			my_game.player.arc_reduction = 1 - upgrade.get_current_effect_modifier()
		#Type.HITPOINTS:
