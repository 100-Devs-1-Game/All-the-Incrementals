class_name AltarStats
extends Resource

@export var element: Altar.Element
@export var minigames: Array[MinigameData]

@export_storage var stored_essence: int
@export_storage var capacity: int = 100
@export_storage var throughput: int = 1
@export_storage var unlocked: bool = false


func tick():
	var amount: int
	for minigame in minigames:
		amount += _calc_generated_amount(minigame)

	var inventory_amount: int = min(amount, throughput)
	var inventory: EssenceInventory = SaveGameManager.world_state.player_state.inventory

	inventory.add_essence(get_essence(), inventory_amount)

	amount -= inventory_amount

	if amount > 0:
		stored_essence = min(stored_essence + amount, capacity)


func _calc_generated_amount(minigame: MinigameData) -> int:
	return (
		SaveGameManager.world_state.player_state.get_average_minigame_highscore(minigame)
		* minigame.currency_conversion_factor
	)


func get_essence() -> Essence:
	match element:
		Altar.Element.EARTH:
			return EssenceInventory.EARTH_ESSENCE
		Altar.Element.FIRE:
			return EssenceInventory.FIRE_ESSENCE
		Altar.Element.WATER:
			return EssenceInventory.WATER_ESSENCE
		Altar.Element.WIND:
			return EssenceInventory.WIND_ESSENCE

	assert(false)
	return null
