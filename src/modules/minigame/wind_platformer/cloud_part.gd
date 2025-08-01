class_name WindPlatformerMinigameCloudPart
extends Node2D

var active: bool = false
var query: PhysicsShapeQueryParameters2D

@onready var orig_pos: Vector2 = position
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	build_query()


func build_query():
	query = PhysicsShapeQueryParameters2D.new()
	query.collision_mask = 1
	query.shape = collision_shape.shape
	query.transform = Transform2D(collision_shape.rotation, Vector2.ZERO)


func _physics_process(delta: float) -> void:
	if not active:
		return

	query.transform.origin = collision_shape.global_position
	var result := get_world_2d().direct_space_state.intersect_shape(query)

	if result:
		var player: Node2D
		player = result[0].collider
		global_position += player.position.direction_to(global_position) * delta * 10
	else:
		position = lerp(position, orig_pos, delta)
