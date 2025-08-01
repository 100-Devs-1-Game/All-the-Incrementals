class_name WTFPhysicsPositionComponent
extends Node2D

#todo remove and refactor everything, now that the main project uses physics interp.
# there will be a few oddities to solve after, I'm sure
# for now things seem fine doing auto + manual interp. but it's a bit sus

var old_physics_position: Vector2
var new_physics_position: Vector2


func _ready():
	teleport(position)


func move(distance: Vector2):
	old_physics_position = new_physics_position
	new_physics_position += distance


func teleport(target: Vector2):
	old_physics_position = target
	new_physics_position = target


func local_interpolated_position() -> Vector2:
	return old_physics_position.lerp(
		new_physics_position, Engine.get_physics_interpolation_fraction()
	)
