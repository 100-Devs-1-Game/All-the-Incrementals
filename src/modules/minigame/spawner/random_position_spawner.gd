class_name RandomPositionSpawner
extends Spawner

#region ------------------------ PRIVATE VARS ----------------------------------

@export var _spawnable_area: CollisionPolygon2D
@export var _spawnable_area_bounding_box: Control
var _random_point_generator: RandomPointGenerator

#endregion

#region ======================== SET UP METHODS ================================


func _ready() -> void:
	_set_up()


func _set_up() -> void:
	_init_random_point_generator()


func _init_random_point_generator() -> void:
	_random_point_generator = RandomPointGenerator.new(
		_spawnable_area.get_polygon(), _spawnable_area_bounding_box.get_global_rect()
	)


#endregion

#region ======================== PUBLIC METHODS ================================


func spawn() -> void:
	spawn_generic_node_at_position(_random_point_generator.get_point())


func spawn_node_at_random_position(node: Node) -> void:
	spawn_at_position(node, _random_point_generator.get_point())

#endregion
