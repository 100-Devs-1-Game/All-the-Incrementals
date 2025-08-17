class_name WorldState
extends Resource

# Dictionary mapping upgrade UIDs to their unlock levels
@export var minigame_unlock_levels: Dictionary[StringName, int]

@export_storage var player_state: PlayerState

@export var altars: Array[AltarStats]


func get_altar(essence: Essence):
	for altar in altars:
		if essence == altar.essence:
			return altar
	assert(false)
	return null
