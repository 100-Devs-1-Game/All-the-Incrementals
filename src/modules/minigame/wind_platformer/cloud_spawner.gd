class_name WindPlatformerMinigameCloudSpawner
extends Node

@export var cloud_scene: PackedScene
@export var clouds_node: Node
@export var initial_clouds: int = 30
@export var cloud_velocity_range: Vector2 = Vector2(20, 150)

@export var initial_rect: Rect2 = Rect2(0, 200, 1920, 1000)

@export var left_rect: Rect2 = Rect2(-150, 200, -140, 1000)
@export var right_rect: Rect2 = Rect2(2060, 200, 2070, 1000)


func start() -> void:
	for i in initial_clouds:
		spawn_cloud(
			initial_rect,
			randf_range(cloud_velocity_range.x, cloud_velocity_range.y) * [-1, 1].pick_random()
		)


func spawn_cloud(rect: Rect2, speed: float):
	#var pos: Vector2= RngUtils.random_point_in_rect(rect)
	var pos := Vector2(
		randf_range(rect.position.x, rect.position.x + rect.size.x),
		randf_range(rect.position.x, rect.position.x + rect.size.x)
	)

	var cloud: WindPlatformerMinigameCloudPlatform = cloud_scene.instantiate()
	cloud.position = pos
	cloud.speed = speed
	clouds_node.add_child(cloud)
