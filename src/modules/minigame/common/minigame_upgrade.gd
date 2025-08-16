@tool
class_name MinigameUpgrade
extends BaseUpgrade

# the custom logic Resource that will apply the upgrade to the specific minigame
@export var logic: BaseMinigameUpgradeLogic

# name of the gameplay feature it unlocks - if any
@export var unlocks_feature: String


func get_max_level() -> int:
	return 0 if not unlocks_feature.is_empty() else super()


func get_description(level: int = -1) -> String:
	var result: String
	if unlocks_feature:
		result = "[Unlocks %s] " % unlocks_feature

	if description_modifier_format == ModifierFormat.UNLOCK:
		return result

	return result + super(level)
