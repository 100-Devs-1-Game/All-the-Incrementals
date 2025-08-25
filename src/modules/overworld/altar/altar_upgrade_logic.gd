class_name AltarUpgradeLogic
extends BaseMinigameUpgradeLogic

enum Type {
	CAPACITY_FLAT = 0,
	CAPACITY_MULTIPLIER = 1,
	THROUGHPUT_FLAT = 2,
	THROUGHPUT_MULTIPLIER = 3,
}

@export var essence: Altar.Element
@export var type: Type


func _apply_effect(_game: BaseMinigame, upgrade: MinigameUpgrade):
	var altar: AltarStats = SaveGameManager.world_state.get_altar_stats(essence)

	match type:
		Type.CAPACITY_FLAT:
			altar.capacity_flat += int(upgrade.get_current_effect_modifier())
		Type.CAPACITY_MULTIPLIER:
			altar.capacity_multiplier += upgrade.get_current_effect_modifier()
		Type.THROUGHPUT_FLAT:
			altar.throughput_flat = int(upgrade.get_current_effect_modifier())
		Type.THROUGHPUT_MULTIPLIER:
			altar.throughput_multiplier = upgrade.get_current_effect_modifier()
