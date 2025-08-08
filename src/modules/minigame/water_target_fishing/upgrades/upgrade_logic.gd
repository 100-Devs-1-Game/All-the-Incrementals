class_name WTFMinigameUpgradeLogic
extends BaseMinigameUpgradeLogic

enum UpgradeType {
	INVALID = 0,
	TODO = 1,
	INCREASE_STARTING_FISH = 2,
	INCREASE_SPAWNING_FISH_RATE = 3,
	INCREASE_OXYGEN_MULT = 4,
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
			push_warning("WTF - todo")
		UpgradeType.INCREASE_STARTING_FISH:
			print("WTF - increasing starting fish by %s" % _upgrade.get_current_effect_modifier())
			stats.spawn_x_starting_fish += _upgrade.get_current_effect_modifier()
		UpgradeType.INCREASE_SPAWNING_FISH_RATE:
			print(
				(
					"WTF - increasing fish spawnrate by %s pixels"
					% (_upgrade.get_current_effect_modifier() * 8)
				)
			)
			stats.spawn_fish_every_x_pixels -= _upgrade.get_current_effect_modifier() * 8
			print(stats.spawn_fish_every_x_pixels)
		UpgradeType.INCREASE_OXYGEN_MULT:
			print(
				(
					"WTF - increasing oxygen mult by %s"
					% (_upgrade.get_current_effect_modifier() * 0.05)
				)
			)
			stats.oxygen_capacity_multiplier += _upgrade.get_current_effect_modifier() * 0.05
			print(stats.oxygen_capacity_multiplier)

		_:
			push_error("WTF - upgrade %s is unknown (%s)" % [_upgrade.name, _upgrade.resource_path])
			assert(false)
