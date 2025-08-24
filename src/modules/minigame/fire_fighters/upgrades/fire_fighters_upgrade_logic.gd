class_name FireFightersMinigameUpgradeLogic
extends BaseMinigameUpgradeLogic

enum Type {
	WALK_SPEED,
	TANK_SIZE,
	WATER_SPEED,
	WATER_SPREAD,
	WATER_ARC_REDUCTION,
	HITPOINTS,
	FIRES,
	BUSHES,
	TREES,
	COUNTDOWN,
	STOMP
}

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
			my_game.player.bonus_water_spread = upgrade.get_current_effect_modifier()
		Type.WATER_ARC_REDUCTION:
			assert(false, "feature removed")
		Type.FIRES:
			my_game.fires_bonus = int(upgrade.get_current_effect_modifier())
		Type.BUSHES:
			my_game.bush_threshold = -upgrade.get_current_effect_modifier()
		Type.TREES:
			my_game.tree_threshold = -upgrade.get_current_effect_modifier()
		Type.COUNTDOWN:
			my_game.countdown_bonus = int(upgrade.get_current_effect_modifier())
		Type.HITPOINTS:
			my_game.player.hitpoint_bonus = int(upgrade.get_current_effect_modifier())
		Type.STOMP:
			my_game.player.can_stomp = true
