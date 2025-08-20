extends Node

@onready var timer: Timer = $"Tick Interval"


func _ready() -> void:
	EventBus.game_loaded.connect(start)


func start(_state: WorldState):
	timer.start()


func _on_timer_timeout() -> void:
	var world_state: WorldState = SaveGameManager.world_state

	world_state.earth_altar.tick()
	world_state.fire_altar.tick()
	world_state.water_altar.tick()
	world_state.wind_altar.tick()

	EventBus.passive_essence_generation_tick.emit()
