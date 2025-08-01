class_name InitialRandomSpawner
extends RandomPositionSpawner

@export var _initial_spawned_total: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_up()
	for i in range(_initial_spawned_total):
		spawn()
