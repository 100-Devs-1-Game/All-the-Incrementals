class_name FireFightersMinigameMapFeature
extends Resource

@export var atlas_coords: Vector2i
@export var flammability: float = 0.5
@export var burn_duration: float = 10.0

@export var spawn_manually: bool = false
@export var spawn_noise: FastNoiseLite
@export var spawn_noise_threshold: float = 0.0
@export var density: float = 1.0

@export var turns_into: FireFightersMinigameMapFeature


func can_burn() -> bool:
	return flammability > 0
