extends Node
# autoload EventBus

# the place for all global signals
# add individual regions for modules

#region Overworld
signal wants_to_travel_to(settlement_data: SettlementData)
#endregion

#region UI
signal ui_credits_done
signal ui_credits_start
#endregion

signal exit_minigame


# For debugging
func _print_all() -> void:
	print([ui_credits_start, ui_credits_done, exit_minigame])
