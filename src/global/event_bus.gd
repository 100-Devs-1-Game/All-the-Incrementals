extends Node
# autoload EventBus

# the place for all global signals
# add individual regions for modules

#region Overworld
signal wants_to_travel_to(settlement_data: SettlementData)
signal request_journal_page_display(data: JournalEntryData)
#endregion

#region Game
signal game_loaded(world_state: WorldState)
signal exit_minigame
signal passive_essence_generation_tick
#endregion

#region UI
signal ui_upgrade_bought(upgrade: BaseUpgrade)
#endregion

#region Audio
signal request_music(song: AudioStream, loop: bool)
# volume: 0.0 - 1.0
signal request_music_volume(volume: float)
#endregion

#region Player
signal stop_player_interaction
signal notify_player_possible_interaction(component: InteractionComponent3D)
signal notify_player_interaction_lost(component: InteractionComponent3D)
#endregion
