@tool
class_name MinigameUpgrade
extends BaseUpgrade

# the custom logic Resource that will apply the upgrade to the specific minigame
@export var logic: BaseMinigameUpgradeLogic

# name of the gameplay feature it unlocks. adding a value here will turn the Upgrade into
# a one level upgrade.
@export var unlocks_feature: String


func get_max_level() -> int:
	return 1 if not unlocks_feature.is_empty() else super()
