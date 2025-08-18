extends Node
# autoload EventBus

# the place for all global signals
# add individual regions for modules

#region Overworld
signal wants_to_travel_to(settlement_data: SettlementData)
signal request_journal_page_display(data: JournalEntryData)
signal request_shrine_ui
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

#region Player
signal stop_player_interaction
#endregion
