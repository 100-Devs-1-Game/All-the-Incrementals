class_name WTFMinigameUpgradeLogic
extends BaseMinigameUpgradeLogic

enum UpgradeType {
	INVALID = 0,
	TODO = 1,
	INCREASE_STARTING_FISH = 2,
	INCREASE_SPAWNING_FISH_RATE = 3,
	INCREASE_OXYGEN_MULT = 4,
	INCREASE_STARTING_SPEED = 5,
	INCREASE_SPEEDBOOST_MULT = 6,
	INCREASE_SPEEDBOOST_FLAT = 7,
}

@export var type: UpgradeType = UpgradeType.INVALID


func _apply_effect(_game: BaseMinigame, _upgrade: MinigameUpgrade):
	if !is_instance_valid(_game) || _game != WTFGlobals.minigame:
		push_error("WTF - minigame is invalid")
		assert(false)
		return

	# any upgrades applied during the game should do nothing - restart the level to see them
	if WTFGlobals.minigame._started:
		print("restart the scene to apply upgrade changes")
		return

	var stats := WTFGlobals.minigame.stats

	match type:
		UpgradeType.TODO:
			push_warning("WTF - todo")
		UpgradeType.INCREASE_STARTING_FISH:
			print("WTF - increasing starting fish by %s" % _upgrade.get_current_effect_modifier())
			stats.spawn_x_starting_fish += _upgrade.get_current_effect_modifier()
			stats.carry_flat += _upgrade.get_current_effect_modifier()
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
		UpgradeType.INCREASE_STARTING_SPEED:
			print(
				(
					"WTF - increasing starting speed by %s"
					% (_upgrade.get_current_effect_modifier() * 25)
				)
			)
			stats.scrollspeed_initial.x -= _upgrade.get_current_effect_modifier() * 25
			print(stats.scrollspeed_initial)
		UpgradeType.INCREASE_SPEEDBOOST_MULT:
			print("WTF - increasing speedboost by %s%%" % _upgrade.get_current_effect_modifier())
			stats.speedboost_multiplier += _upgrade.get_current_effect_modifier() / 100.0
			print(stats.speedboost_multiplier)
		UpgradeType.INCREASE_SPEEDBOOST_FLAT:
			print("WTF - increasing speedboost by +%s" % _upgrade.get_current_effect_modifier())
			stats.speedboost_flat += _upgrade.get_current_effect_modifier()
			print(stats.speedboost_flat)
		_:
			push_error("WTF - upgrade %s is unknown (%s)" % [_upgrade.name, _upgrade.resource_path])
			assert(false)
