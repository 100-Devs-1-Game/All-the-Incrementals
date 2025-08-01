class_name ExampleMinigameUpgradeLogic
extends BaseMinigameUpgradeLogic

enum UpgradeType { SPEED, SIZE }

@export var type: UpgradeType


func _apply_effect(p_game: BaseMinigame, upgrade: MinigameUpgrade):
	var game: ExampleMinigame = p_game

	match type:
		UpgradeType.SPEED:
			game.rotation_speed = upgrade.get_effect_modifier(upgrade.current_level)
		UpgradeType.SIZE:
			game.circle_center.scale = (
				Vector2.ONE * upgrade.get_effect_modifier(upgrade.current_level)
			)
