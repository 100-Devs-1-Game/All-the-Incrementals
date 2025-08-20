extends Area2D

const RAY_POLL_COUNT: int = 8
const RAY_COVERAGE: float = 100

@export var volume_fadeout: Curve
@export var rubberband: Curve

@export var starting_speed: float = 400.0
@export var acceleration: float = 30.0
@export var acceleration_acceleration: float = 7.5

var player: Node2D
## used for upgrades to reduce overall speed
var speed_mod: float = 1.0
var current_speed: float = starting_speed
var repel_strength: float = 0.0
var drag_strength: float = 400

@onready var whispers: AudioStreamPlayer = $Whispers


func _init() -> void:
	WaterRowingRapidsMinigameUpgradeLogic.multiregister_base(self, [&"speed_mod"])


func _ready() -> void:
	volume_fadeout.bake()
	rubberband.bake()


func _process(_delta: float) -> void:
	var distance := get_distance()
	var fade := volume_fadeout.sample_baked(distance)
	Music._music_player.volume_linear = fade
	whispers.volume_linear = 1.0 - fade


func _physics_process(delta: float) -> void:
	var rubberbanded_speed = rubberband.sample_baked(get_distance()) * current_speed * speed_mod
	position.x += rubberbanded_speed * delta
	current_speed += acceleration * delta
	acceleration += acceleration_acceleration * delta
	for body in get_overlapping_bodies():
		body.take_damage(delta * 20.0)
		_do_grab(body)


func repel() -> void:
	current_speed -= repel_strength
	print("REPELLED\nREPELLED\nREPELLED\n", current_speed)


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
	var average_position: Vector2 = Vector2.ZERO
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
