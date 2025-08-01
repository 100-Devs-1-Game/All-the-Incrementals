class_name ExampleMinigameUpgradeLogic
extends BaseMinigameUpgradeLogic

enum UpgradeType { SPEED, SIZE }

@export var type: UpgradeType


func _apply_effect(p_game: BaseMinigame, upgrade: MinigameUpgrade):
	var game: ExampleMinigame = p_game

	var effect_modifier: float = upgrade.get_current_effect_modifier()
	match type:
		UpgradeType.SPEED:
			game.rotation_speed = effect_modifier
		UpgradeType.SIZE:
			game.circle_center.scale = Vector2.ONE * effect_modifier
