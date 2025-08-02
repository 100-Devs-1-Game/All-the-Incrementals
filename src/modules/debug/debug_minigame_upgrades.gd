class_name DebugMinigameUpgrades
extends Node

var _tree_upgrades: TreeItem
var _tree_callables: Dictionary
var _tree_root: TreeItem


func set_tree(tree_callables: Dictionary, tree_root: TreeItem) -> void:
	_tree_callables = tree_callables
	_tree_root = tree_root


func setup_upgrade_items():
	assert(SceneLoader.has_current_minigame())

	var data: MinigameData = SceneLoader.get_current_minigame()

	_tree_upgrades = _tree_root.create_child()
	_tree_upgrades.set_text(0, "Minigame upgrades")

	for upgrade in data.get_all_upgrades():
		_add_upgrade_item(upgrade)


func _add_upgrade_item(upgrade: BaseUpgrade) -> void:
	var new_item = _tree_upgrades.create_child()
	var label = _get_upgrade_button_text(upgrade)
	new_item.set_text(0, label)
	var item_pressed = Callable(self, "_on_upgrade_item_pressed").bind(new_item, upgrade)
	_tree_callables[new_item.get_instance_id()] = item_pressed
	var hotkey = ""
	# We can implement hotkeys for upgrade buttons, we just nxeed a place to
	# define the key associated with a specific upgrade in BaseUpgrade.
	if hotkey != "":
		label = "[" + hotkey + "] " + label
	else:
		label = label


func _get_upgrade_button_text(upgrade: BaseUpgrade) -> String:
	return "%s Lvl %d" % [upgrade.name, upgrade.current_level + 1]


func _on_upgrade_item_pressed(item: TreeItem, upgrade: BaseUpgrade):
	upgrade.level_up()
	if upgrade is MinigameUpgrade:
		if upgrade.logic:
			upgrade.logic._apply_effect(get_tree().current_scene, upgrade)
	else:
		assert(false, "Not implemented yet")

	item.set_text(0, _get_upgrade_button_text(upgrade))
