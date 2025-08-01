extends Node
# autoload EventBus

# the place for all global signals
# add individual regions for modules

#region Game
signal game_loaded(world_state: WorldState)
#endregion

#region UI
signal ui_credits_done
signal ui_credits_start
signal ui_upgrade_bought(upgrade: BaseUpgrade)
#endregion

signal exit_minigame


# For debugging
func _print_all() -> void:
	print([ui_credits_start, ui_credits_done, exit_minigame])
