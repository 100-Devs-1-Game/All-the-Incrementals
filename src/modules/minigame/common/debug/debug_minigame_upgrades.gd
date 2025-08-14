class_name DebugMinigameUpgrades
extends Node

@export var debug_popup: DebugPopup

var minigame: BaseMinigame
var _tree_upgrades: TreeItem


func _ready() -> void:
	await get_tree().process_frame
	init()


func init():
	assert(SceneLoader.has_current_minigame())
	assert(minigame != null)

	var tree_root = debug_popup.get_tree_root()
	_tree_upgrades = tree_root.create_child()
	_tree_upgrades.set_text(0, "Minigame upgrades")
	_add_minigame_upgrades_children()


func _add_minigame_upgrades_children() -> void:
	for upgrade in minigame.data.get_all_upgrades():
		assert(upgrade.logic)
		_add_upgrade_item(upgrade)

	var max_out_item = _tree_upgrades.create_child()
	max_out_item.set_text(0, "Max out upgrades")
	debug_popup.link_callable(max_out_item, _max_out_upgrades)

	var reset_item = _tree_upgrades.create_child()
	reset_item.set_text(0, "Reset all upgrades")
	debug_popup.link_callable(reset_item, _reset_upgrades)


func _refresh_minigame_upgrades_branch() -> void:
	for item in _tree_upgrades.get_children():
		_tree_upgrades.remove_child(item)
	_add_minigame_upgrades_children()


func _reset_upgrades() -> void:
	print("Resetting all upgrades")
	minigame.data.reset_all_upgrades()
	_refresh_minigame_upgrades_branch()
	# Resetting the upgrades cannot be done during game play, because upgrades
	# don't store any "default state information"
	SceneLoader.enable_immediate_play()
	SceneLoader.start_minigame(minigame.data)


func _max_out_upgrades() -> void:
	print("Maxing out all upgrades")
	for upgrade in minigame.data.get_all_upgrades():
		while not upgrade.is_maxed_out():
			upgrade.level_up()

	_refresh_minigame_upgrades_branch()


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
	return "%s Lvl %d/%d" % [upgrade.name, upgrade.get_level() + 1, upgrade.get_max_level() + 1]


func _on_upgrade_item_pressed(item: TreeItem, upgrade: BaseUpgrade):
	if debug_popup.was_rmb():
		upgrade.level_down()
	else:
		upgrade.level_up()

	if upgrade is MinigameUpgrade:
		if upgrade.logic:
			upgrade.logic._apply_effect(get_tree().current_scene, upgrade)
	else:
		assert(false, "Not implemented yet")

	item.set_text(0, _get_upgrade_button_text(upgrade))
