class_name DebugMinigameUpgrades
extends Node

@export var debug_popup: DebugPopup

var _tree_upgrades: TreeItem


func _ready() -> void:
	await get_tree().current_scene.ready
	init()


func init():
	assert(SceneLoader.has_current_minigame())

	var data: MinigameData = SceneLoader.get_current_minigame()

	var tree_root = debug_popup.get_tree_root()
	_tree_upgrades = tree_root.create_child()
	_tree_upgrades.set_text(0, "Minigame upgrades")

	for upgrade in data.get_all_upgrades():
		_add_upgrade_item(upgrade)


func _add_upgrade_item(upgrade: BaseUpgrade) -> void:
	var new_item = _tree_upgrades.create_child()
	var label = _get_upgrade_button_text(upgrade)
	new_item.set_text(0, label)
	var item_pressed = Callable(self, "_on_upgrade_item_pressed").bind(new_item, upgrade)
	debug_popup.link_callable(new_item, item_pressed)
	# We can implement hotkeys for upgrade buttons, we just nxeed a place to
	# define the key associated with a specific upgrade in BaseUpgrade.
	var hotkey = ""
	debug_popup.register_hotkey(hotkey, item_pressed)
	if hotkey != "":
		label = "[" + hotkey + "] " + label
	else:
		label = label


func _get_upgrade_button_text(upgrade: BaseUpgrade) -> String:
	return "%s Lvl %d" % [upgrade.name, upgrade.get_level() + 1]


func _on_upgrade_item_pressed(item: TreeItem, upgrade: BaseUpgrade):
	upgrade.level_up()
	if upgrade is MinigameUpgrade:
		if upgrade.logic:
			upgrade.logic._apply_effect(get_tree().current_scene, upgrade)
	else:
		assert(false, "Not implemented yet")

	item.set_text(0, _get_upgrade_button_text(upgrade))
