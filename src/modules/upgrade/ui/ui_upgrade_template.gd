extends Node2D
var base_upgrade: BaseUpgrade
var upgrade_tree: UpgradeTree
var level_text: String
var cost_text: String
var name_text: String


func init(upgradetree: UpgradeTree, essence_type: String):
	EventBus.ui_upgrade_bought.connect(reload_base_upgrade_data)
	upgrade_tree = upgradetree
	match essence_type:
		"Wind":
			$Background.texture = load("res://assets/ui/upgrade_tree/wind_off.webp")
			$BackgroundActive.texture = load("res://assets/ui/upgrade_tree/wind_on.webp")
		"Fire":
			$Background.texture = load("res://assets/ui/upgrade_tree/fire_off.webp")
			$BackgroundActive.texture = load("res://assets/ui/upgrade_tree/fire_on.webp")
		"Water":
			$Background.texture = load("res://assets/ui/upgrade_tree/water_off.webp")
			$BackgroundActive.texture = load("res://assets/ui/upgrade_tree/water_on.webp")
		"Earth":
			$Background.texture = load("res://assets/ui/upgrade_tree/earth_off.webp")
			$BackgroundActive.texture = load("res://assets/ui/upgrade_tree/earth_on.webp")


func reload_base_upgrade_data(_upgrade = null) -> void:
	_set_icon()
	_set_level_text()
	_set_cost_text()
	_set_name_text()
	_set_description_text()
	_set_background()
	_set_foreground()
	if _upgrade == base_upgrade:
		_on_select()


func _set_icon() -> void:
	$Icon.texture = base_upgrade.icon
	_resize_texture($Background.texture.get_size())


func _resize_texture(target_size: Vector2):
	if $Icon.texture == null:
		return
	var tex_size = $Icon.texture.get_size()
	if tex_size.x == 0 or tex_size.y == 0:
		return
	$Icon.scale = target_size / tex_size


func _set_level_text() -> void:
	var level: String = ""
	level += str(base_upgrade.get_level_index() + 1)
	level += "/"
	level += str(base_upgrade.get_max_level() + 1)
	level_text = level


func _set_cost_text() -> void:
	if base_upgrade.is_maxed_out():
		cost_text = "[color=red]max[/color]"
		return
	var cost: String = ""
	var e: EssenceInventory = base_upgrade.get_next_level_cost()
	if e.earth > 0:
		cost += "[img=50]res://assets/icons/glowing_earth_skn.png[/img]" + str(e.earth) + "\n"
	if e.fire > 0:
		cost += "[img=50]res://assets/icons/glowing_fire_skn.png[/img]" + str(e.fire) + "\n"
	if e.water > 0:
		cost += "[img=50]res://assets/icons/glowing_water_skn.png[/img]" + str(e.water) + "\n"
	if e.wind > 0:
		cost += "[img=50]res://assets/icons/glowing_wind_skn.png[/img]" + str(e.wind) + "\n"
	cost_text = cost.trim_suffix("\n")


func _set_name_text() -> void:
	name_text = base_upgrade.name


func _set_description_text() -> void:
	pass  #$Description.text = base_upgrade.get_description()


func _set_background() -> void:
	$BackgroundActive.visible = base_upgrade.is_unlocked()


func _set_foreground() -> void:
	if base_upgrade.is_maxed_out():
		$Foreground.visible = true


func _on_select() -> void:
	upgrade_tree.change_display(
		base_upgrade, name_text, cost_text, level_text, base_upgrade.get_description()
	)


func _on_click_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_on_select()
