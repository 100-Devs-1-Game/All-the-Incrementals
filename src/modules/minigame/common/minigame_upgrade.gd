@tool
class_name MinigameUpgrade
extends BaseUpgrade

# the custom logic Resource that will apply the upgrade to the specific minigame
@export var logic: BaseMinigameUpgradeLogic

# name of the gameplay feature it unlocks - if any
@export var unlocks_feature: String


func get_description(level: int = -1) -> String:
	var result: String
	if unlocks_feature:
		result = "[Unlocks %s] " % unlocks_feature

	if description_modifier_format == ModifierFormat.UNLOCK:
		return description_prefix

	return result + super(level)
