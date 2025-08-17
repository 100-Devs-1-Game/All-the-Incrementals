class_name AltarUpgradeLogic
extends BaseMinigameUpgradeLogic

enum Type { CAPACITY, THROUGHPUT }

@export var essence: Essence
@export var type: Type


func _apply_effect(_game: BaseMinigame, upgrade: MinigameUpgrade):
	var altar: AltarStats = SaveGameManager.world_state.get_altar(essence)

	match type:
		Type.CAPACITY:
			altar.capacity = upgrade.get_current_effect_modifier()
		Type.THROUGHPUT:
			altar.throughput = upgrade.get_current_effect_modifier()
