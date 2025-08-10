extends Node
# autoload EventBus

# the place for all global signals
# add individual regions for modules

#region Overworld
signal wants_to_travel_to(settlement_data: SettlementData)
#endregion

#region Game
signal game_loaded(world_state: WorldState)
signal exit_minigame
#endregion

#region UI
signal ui_upgrade_bought(upgrade: BaseUpgrade)
#endregion

#region Audio
signal request_music(song: AudioStream)
#endregion
