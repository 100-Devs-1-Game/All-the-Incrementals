extends Node

@export var shrine_data: MinigameData = preload("res://modules/overworld/data/shrine_data.tres")
@onready var timer: Timer = $"Tick Interval"


func _ready() -> void:
	EventBus.game_loaded.connect(start)
	EventBus.apply_shrine_upgrades.connect(shrine_data.apply_all_upgrades.bind(null))


func start(_state: WorldState):
	timer.start()


func get_progress() -> float:
	if timer.is_stopped():
		return 0
	return 1.0 - timer.time_left / timer.wait_time


func _on_timer_timeout() -> void:
	var world_state: WorldState = SaveGameManager.world_state
	shrine_data.apply_all_upgrades(null)
	world_state.earth_altar.tick()
	world_state.fire_altar.tick()
	world_state.water_altar.tick()
	world_state.wind_altar.tick()

	EventBus.passive_essence_generation_tick.emit()
