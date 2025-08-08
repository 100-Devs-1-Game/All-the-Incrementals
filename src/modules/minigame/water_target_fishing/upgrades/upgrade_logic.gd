class_name WTFMinigameUpgradeLogic
extends BaseMinigameUpgradeLogic

enum UpgradeType {
	INVALID,
	TODO,
	INCREASE_STARTING_FISH,
}

@export var type: UpgradeType = UpgradeType.INVALID


func _apply_effect(_game: BaseMinigame, _upgrade: MinigameUpgrade):
	if !is_instance_valid(_game) || _game != WTFGlobals.minigame:
		push_error("WTF - minigame is invalid")
		assert(false)
		return

	var stats := WTFGlobals.minigame.stats

	match type:
		UpgradeType.TODO:
			print("WTF - todo")
		UpgradeType.INCREASE_STARTING_FISH:
			print("WTF - increasing starting fish by %d", _upgrade.get_current_effect_modifier())
			stats.spawn_x_starting_fish += _upgrade.get_current_effect_modifier()
		_:
			push_error("WTF - upgrade %s is unknown (%s)" % [_upgrade.name, _upgrade.resource_path])
			assert(false)
