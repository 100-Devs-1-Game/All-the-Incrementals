class_name WTFParallaxComponent
extends Node2D

# tbh I have no idea how the godot builtin parallax nodes work and it scares me
# so...
# tldr this is the endless runner magic sauce to get things moving
# relative to the players "fake" speed

@export var target: Node2D
@export var min_movement_multiplier: float = 1
@export var max_movement_multiplier: float = 1
@export var base_speed: float = 0

var movement_multiplier: float = 0


func _ready() -> void:
	movement_multiplier = randf_range(min_movement_multiplier, max_movement_multiplier)

	if !target:
		target = get_parent()


func _physics_process(delta: float) -> void:
	target.position.x += (
		(base_speed + WTFGlobals.minigame.current_velocity.x) * delta * movement_multiplier
	)
