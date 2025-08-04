extends Node2D
@export var base_upgrade: BaseUpgrade


func reload_base_upgrade_data() -> void:
	_set_icon()
	_set_level_text()
	_set_description_text()


func _set_icon() -> void:
	$Icon.texture = base_upgrade.icon


func _set_level_text() -> void:
	var level: String = ""
	level += str(base_upgrade.get_level())
	level += "/"
	level += str(base_upgrade.get_max_level())
	$Level.text = level


func _set_description_text() -> void:
	$Description.text = base_upgrade.get_description()
