class_name AltarUpgradeLogic
extends OverworldUpgradeLogic

enum Type { CAPACITY, THROUGHPUT }


func _apply_effect(upgrade: OverworldUpgrade):
	var altar_upgrade: AltarUpgrade = upgrade
