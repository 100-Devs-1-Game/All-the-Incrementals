class_name AltarStats
extends Resource

@export var element: Altar.Element
@export var minigames: Array[MinigameData]

@export_storage var stored_essence: int
@export_storage var unlocked: bool = false

var capacity_base: int = 100
var throughput_base: int = 1

var capacity_flat: int = 0
var capacity_multiplier: float = 0

var throughput_flat: int = 0
var throughput_multiplier: float = 0


func tick():
	var amount: int = 0
	for minigame in minigames:
		amount += calc_generated_amount(minigame)

	var inventory_amount: int = min(amount, get_throughput())
	var inventory: EssenceInventory = SaveGameManager.world_state.player_state.inventory

	inventory.add_essence(get_essence(), inventory_amount)

	amount -= inventory_amount

	if amount > 0:
		stored_essence = min(stored_essence + amount, get_capacity())


func calc_generated_amount(minigame: MinigameData) -> int:
	return int(
		(
			SaveGameManager.world_state.player_state.get_average_minigame_highscore(minigame)
			* minigame.currency_conversion_factor
		)
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


func get_capacity() -> int:
	return floori(capacity_base + (capacity_flat * (1.0 + capacity_multiplier)))


func get_throughput() -> int:
	return floori(throughput_base + (throughput_flat * (1.0 + throughput_multiplier)))
