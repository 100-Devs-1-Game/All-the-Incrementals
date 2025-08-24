class_name CurrentEssenceDisplay
extends Control


func _ready() -> void:
	EventBus.ui_upgrade_bought.connect(refresh_labels)
	EventBus.passive_essence_generation_tick.connect(refresh_labels)
	refresh_labels()


func refresh_labels(_upgrade = null) -> void:
	var inventory = Player.data.inventory
	$Panel/HBoxContainer/WaterLabel.text = "%5d" % inventory.water
	$Panel/HBoxContainer/EarthLabel.text = "%5d" % inventory.earth
	$Panel/HBoxContainer/FireLabel.text = "%5d" % inventory.fire
	$Panel/HBoxContainer/WindLabel.text = "%5d" % inventory.wind
