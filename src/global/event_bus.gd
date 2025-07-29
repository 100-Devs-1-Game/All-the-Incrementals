extends Node
# autoload EventBus

# the place for all global signals
# add individual regions for modules

#region UI
signal ui_credits_done
signal ui_credits_start
#endregion


# For debugging
func _print_all() -> void:
	print([ui_credits_start, ui_credits_done])
