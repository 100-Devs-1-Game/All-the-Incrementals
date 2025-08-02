class_name WTFMinigame
extends Node2D

@export var fish: PackedScene

var camera: WTFCamera2D
var player: WTFPlayer

var current_velocity: Vector2 = Vector2(-200, 0)
var base_slow: float = 100

var score: int = 0
var distance_travelled = 0
var distance_travelled_left_to_spawn = 0
var score_weight_modifier = 3


func _ready() -> void:
	player = get_tree().get_first_node_in_group("wtf_player")
	assert(player)

	camera = get_tree().get_first_node_in_group("wtf_camera")
	assert(camera)


func _physics_process(delta: float) -> void:
	current_velocity.x += (base_slow + (score * score_weight_modifier)) * delta

	# effectively stopped
	if current_velocity.x >= 0:
		current_velocity.x = 0
		# hack that acts as a one second timer before the run ends
		if player.oxygen_remaining_seconds <= -1:
			#todo end the run and show summary or ui to restart or buy upgrades
			get_tree().reload_current_scene()

	distance_travelled += -current_velocity.x
	distance_travelled_left_to_spawn += -current_velocity.x

	#todo replace with good spawning
	while distance_travelled_left_to_spawn > 1000:
		var f: WTFFish = fish.instantiate()
		f.position.x = (
			distance_travelled
			+ camera.get_visible_rect().position.x
			+ camera.get_visible_rect().size.x
			+ randf_range(-current_velocity.x, -current_velocity.x * 4)
		)
		f.position.y = randf_range(
			min(0, camera.get_visible_rect().position.y),
			min(0, camera.get_visible_rect().position.y) + camera.get_visible_rect().size.y
		)
		%Entities.add_child(f)
		distance_travelled_left_to_spawn -= 100
