class_name AltarUpgradeLogic
extends OverworldUpgradeLogic

enum Type { CAPACITY, THROUGHPUT }

@export var type: Type


func _apply_effect(upgrade: OverworldUpgrade):
	var altar_upgrade: AltarUpgrade = upgrade
