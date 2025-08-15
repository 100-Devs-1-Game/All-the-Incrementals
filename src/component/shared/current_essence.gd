class_name CurrentEssenceDisplay
extends Control


func _ready() -> void:
	EventBus.ui_upgrade_bought.connect(_refresh_labels)
	_refresh_labels()


func _refresh_labels(_upgrade = null) -> void:
	var inventory = Player.data.inventory
	$Panel/HBoxContainer/WaterLabel.text = "%4d" % inventory.water
	$Panel/HBoxContainer/EarthLabel.text = "%4d" % inventory.earth
	$Panel/HBoxContainer/FireLabel.text = "%4d" % inventory.fire
	$Panel/HBoxContainer/WindLabel.text = "%4d" % inventory.wind
