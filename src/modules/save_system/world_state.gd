class_name WorldState
extends Resource

# Dictionary mapping upgrade UIDs to their unlock levels
@export var minigame_unlock_levels: Dictionary[StringName, int]

@export_storage var player_state: PlayerState

@export var earth_altar: AltarStats
@export var fire_altar: AltarStats
@export var water_altar: AltarStats
@export var wind_altar: AltarStats


func get_altar_stats(element: Altar.Element) -> AltarStats:
	match element:
		Altar.Element.EARTH:
			return earth_altar
		Altar.Element.FIRE:
			return fire_altar
		Altar.Element.WATER:
			return water_altar
		Altar.Element.WIND:
			return wind_altar

	assert(false)
	return null
