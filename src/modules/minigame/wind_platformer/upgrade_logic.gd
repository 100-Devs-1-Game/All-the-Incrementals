class_name WindPlatformerMinigameUpgradeLogic
extends BaseMinigameUpgradeLogic

enum Type { MOVE_SPEED }

@export var type: Type


func _apply_effect(game: BaseMinigame, upgrade: MinigameUpgrade):
	var my_game: WindPlatformerMinigame = game

	match type:
		Type.MOVE_SPEED:
			my_game.player.move_speed *= upgrade.get_current_effect_modifier()
