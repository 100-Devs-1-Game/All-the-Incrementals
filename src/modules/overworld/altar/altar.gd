class_name Altar
extends Node3D

enum Element { EARTH, FIRE, WATER, WIND }

@export var element: Element
@export var minigames: Array[MinigameData]


func tick():
	var amount: int
	for minigame in minigames:
		amount += _calc_generated_amount(minigame)

	var stats: AltarStats = get_stats()

	var inventory_amount: int = min(amount, stats.throughput)
	var inventory: EssenceInventory = SaveGameManager.world_state.player_state.inventory

	inventory.add_essence(get_essence(), inventory_amount)

	amount -= inventory_amount

	if amount > 0:
		stats.stored_essence = min(stats.stored_essence + amount, stats.capacity)


func _calc_generated_amount(minigame: MinigameData) -> int:
	return (
		SaveGameManager.world_state.player_state.get_average_minigame_highscore(minigame)
		* minigame.currency_conversion_factor
	)


func get_stats() -> AltarStats:
	return SaveGameManager.world_state.get_altar_stats(element)


func get_essence() -> Essence:
	match element:
		Element.EARTH:
			return EssenceInventory.EARTH_ESSENCE
		Element.FIRE:
			return EssenceInventory.FIRE_ESSENCE
		Element.WATER:
			return EssenceInventory.WATER_ESSENCE
		Element.WIND:
			return EssenceInventory.WIND_ESSENCE

	assert(false)
	return null


func _on_interaction_component_interacted_with(_player: SpiritkeeperCharacterController3D) -> void:
	pass  # Replace with function body.
