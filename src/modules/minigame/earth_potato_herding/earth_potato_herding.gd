class_name EarthPotatoHerdingMinigame
extends BaseMinigame

# Upgrade signals
signal nutritious_potato(value: float)
signal spirit_keeper_brightness(value: float)
signal spirit_keeper_speed(value: float)

# Game signals
signal game_started


func _initialize() -> void:
	nutritious_potato.emit(1.0)
	spirit_keeper_brightness.emit(1.0)
	spirit_keeper_speed.emit(1.0)
	data.apply_all_upgrades(self)


func _start() -> void:
	$DebugPopup/DebugMinigameUpgrades.init()
	game_started.emit()
