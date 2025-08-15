extends Area2D

const RAY_POLL_COUNT: int = 8
const RAY_COVERAGE: float = 100

@export var volume_fadeout: Curve
@export var rubberband: Curve

var player: Node2D

var speed: float = 700.0
var drag_strength: float = 400

@onready var whispers: AudioStreamPlayer = $Whispers


func _init() -> void:
	WaterRowingRapidsMinigameUpgradeLogic.multiregister_base(self, [&"speed"])


func _ready() -> void:
	volume_fadeout.bake()
	rubberband.bake()


func _process(_delta: float) -> void:
	var distance := get_distance()
	var fade := volume_fadeout.sample_baked(distance)
	Music._music_player.volume_linear = fade
	whispers.volume_linear = 1.0 - fade


func _physics_process(delta: float) -> void:
	var rubberbanded_speed = rubberband.sample_baked(get_distance()) * speed
	position.x += rubberbanded_speed * delta

	for body in get_overlapping_bodies():
		body.take_damage(delta * 20.0)
		_do_grab(body)


func get_distance() -> float:
	return maxf(player.position.x, position.x) - position.x


func _do_grab(body: RigidBody2D) -> void:
	if global_position.x > body.global_position.x:  #fullt lost in the sauce. Max drag.
		body.apply_central_force(Vector2(-drag_strength, 0.0))
		return
	# Otherwise we do a lot of math
	var space_state := get_viewport().world_2d.direct_space_state
	var ray_query := PhysicsRayQueryParameters2D.new()
	ray_query.collision_mask = 0b100
	ray_query.hit_from_inside = true
	var average_position: Vector2
	var hits: int = 0

	for i in RAY_POLL_COUNT:
		ray_query.from.y = (
			i * RAY_COVERAGE / RAY_POLL_COUNT - RAY_COVERAGE / 2.0 + body.global_position.y
		)
		ray_query.to.y = ray_query.from.y
		ray_query.from.x = global_position.x
		ray_query.to.x = global_position.x + 80
		var result = space_state.intersect_ray(ray_query)
		if result.is_empty():
			continue
		average_position += result.position
		hits += 1
	if hits == 0:
		return

	average_position /= hits
	body.apply_force(Vector2(-drag_strength, 0.0), average_position - body.global_position)
