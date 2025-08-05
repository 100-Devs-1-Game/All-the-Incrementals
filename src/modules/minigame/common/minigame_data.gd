class_name MinigameData
extends Resource

# Minigame name in-game
@export var display_name: String

# the game scene of this Minigame
@export var minigame_scene: PackedScene

# the root nodes ( entry points ) of the Minigames Upgrade Tree
@export var upgrade_tree_root_nodes: Array[MinigameUpgrade]

# Essence player gains from playing this
@export var output_essence: Essence
# turns score into Essence
@export var currency_conversion_factor: float

# stores the top n highscores
@export_storage var high_scores: Array[int]


## Returns all upgrades in the tree via recursion
func get_all_upgrades(branch: BaseUpgrade = null, unlocked_only: bool = false) -> Array[Resource]:
	var result: Array[Resource]
	var root_nodes: Array[Resource]

	if branch:
		root_nodes = branch.unlocks
	else:
		# Array type conversion BaseUpgrade <- upgrade_tree_root_nodes
		root_nodes.assign(upgrade_tree_root_nodes)

	for upgrade in root_nodes:
		if unlocked_only and upgrade.get_level() <= -1:
			continue
		result.append(upgrade)
		result.append_array(get_all_upgrades(upgrade, unlocked_only))

	return result


func apply_all_upgrades(minigame: BaseMinigame) -> void:
	for upgrade in get_all_upgrades(null, true):
		var minigame_upgrade: MinigameUpgrade = upgrade
		if not minigame_upgrade.logic:
			push_error("Found an upgrade with no associated logic")
			continue
		minigame_upgrade.logic._apply_effect(minigame, minigame_upgrade)


func reset_all_upgrades() -> void:
	for upgrade in get_all_upgrades():
		SaveGameManager.world_state.minigame_unlock_levels[upgrade.get_uid()] = -1
	SaveGameManager.save()
