extends Area2D

## Magnetism strength at minimum distance, in pixels per second per second.
var magnetism_strength: float = 40
## Distance considered the "Maximum"
var max_distance: float = 800

# Fuck it. hacky solution.


func _physics_process(delta: float) -> void:
	for spirit in get_overlapping_areas():
		var relative: Vector2 = global_position - spirit.owner.global_position
		spirit.owner.velocity += (
			(relative * (1 - minf(relative.length() / max_distance, 1)))
			* magnetism_strength
			* delta
		)
		print((1 - minf(relative.length() / max_distance, 1)) * magnetism_strength * delta)
