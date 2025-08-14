class_name WindPlatformerMinigameCloudSpawner
extends Node2D

signal cloud_spawned(cloud: WindPlatformerMinigameCloudPlatform)

@export var cloud_scene: PackedScene
@export var clouds_node: Node
@export var initial_clouds: int = 30
@export var cloud_velocity_range: Vector2 = Vector2(20, 150)

@export var initial_rect: Rect2 = Rect2(0, 200, 1920, 1000)

var cloud_bonus: int = 0
var multiplier_2x_chance: float = 0.0
var multiplier_5x_chance: float = 0.0

var _off_screen_spawn_offset := Vector2(0, 200)
var _off_screen_spawn_size := Vector2(10, 800)
var _left_rect: Rect2
var _right_rect: Rect2

@onready var timer: Timer = $Timer


func _ready() -> void:
	var viewport := get_viewport_rect().size

	var x_offset: int = 100

	_left_rect = Rect2(
		_off_screen_spawn_offset - Vector2(x_offset, 0) - Vector2(_off_screen_spawn_size.x, 0),
		_off_screen_spawn_size
	)
	_right_rect = Rect2(
		_off_screen_spawn_offset + Vector2(viewport.x + x_offset, 0), _off_screen_spawn_size
	)


func start() -> void:
	for i in initial_clouds + cloud_bonus:
		spawn_cloud(initial_rect)
	timer.start()


func spawn_cloud(rect: Rect2, force_direction: int = 0):
	var pos := Vector2(
		randf_range(rect.position.x, rect.position.x + rect.size.x),
		randf_range(rect.position.y, rect.position.y + rect.size.y)
	)

	var cloud: WindPlatformerMinigameCloudPlatform = cloud_scene.instantiate()
	cloud.position = pos
	var dir: int = force_direction
	if dir == 0:
		dir = [-1, 1].pick_random()

	cloud.speed = randf_range(cloud_velocity_range.x, cloud_velocity_range.y) * dir

	if RngUtils.chance100(multiplier_5x_chance):
		cloud.score_multiplier = 5
	elif RngUtils.chance100(multiplier_2x_chance):
		cloud.score_multiplier = 2

	clouds_node.add_child(cloud)
	cloud_spawned.emit(cloud)


func _on_timer_timeout() -> void:
	if clouds_node.get_child_count() >= initial_clouds + cloud_bonus:
		return

	if RngUtils.chance100(50):
		spawn_cloud(_left_rect, 1)
	else:
		spawn_cloud(_right_rect, -1)
