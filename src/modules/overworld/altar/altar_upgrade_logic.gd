class_name AltarUpgradeLogic
extends BaseMinigameUpgradeLogic

enum Altar { EARTH, FIRE, WATER, WIND }
enum Type { CAPACITY, THROUGHPUT }

@export var essence: Altar
@export var type: Type


func _apply_effect(_game: BaseMinigame, upgrade: MinigameUpgrade):
	var altar: AltarStats

	match essence:
		Altar.EARTH:
			altar = SaveGameManager.world_state.earth_altar
		Altar.FIRE:
			altar = SaveGameManager.world_state.fire_altar
		Altar.WATER:
			altar = SaveGameManager.world_state.water_altar
		Altar.WIND:
			altar = SaveGameManager.world_state.wind_altar

	match type:
		Type.CAPACITY:
			altar.capacity = int(upgrade.get_current_effect_modifier())
		Type.THROUGHPUT:
			altar.throughput = int(upgrade.get_current_effect_modifier())
