class_name WindPlatformerMinigame
extends BaseMinigame

@export var wind_noise: FastNoiseLite
@export var size: Vector2i = Vector2i(2000, 1100)

@export var num_particles: int = 1200

@export_category("Debug")
@export var disable_game_over: bool = false

var wind_arr: Dictionary
var particles: Array[WindPlatformerMinigameParticle]

@onready var player: WindPlatformerMinigamePlayer = $Player
@onready var multi_mesh_instance: MultiMeshInstance2D = $MultiMeshInstance2D
@onready var cloud_spawner: WindPlatformerMinigameCloudSpawner = $"Cloud Spawner"


func _initialize() -> void:
	wind_noise.seed = randi()
	for i in num_particles:
		spawn_random_particle()


func _start():
	cloud_spawner.start()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_F1:
				PerformanceUtils.TrackAverage.dump("draw particles")
				PerformanceUtils.TrackAverage.dump("tick particles")
				get_tree().quit()


func _process(delta: float) -> void:
	draw_particles(delta)


func _physics_process(delta: float) -> void:
	if Engine.get_physics_frames() % 2 == 0:
		PerformanceUtils.TrackAverage.start_tracking("tick particles")
		tick_particles(delta * 2)
		PerformanceUtils.TrackAverage.stop_tracking("tick particles")


func draw_particles(delta: float):
	PerformanceUtils.TrackAverage.start_tracking("draw particles")
	multi_mesh_instance.multimesh.instance_count = particles.size()
	var i := 0
	for particle: WindPlatformerMinigameParticle in particles:
		particle.tick(delta)
		if not particle.velocity.is_equal_approx(Vector2.ZERO):
			multi_mesh_instance.multimesh.set_instance_transform_2d(
				i, Transform2D(particle.velocity.angle(), particle.position)
			)
		i += 1
	PerformanceUtils.TrackAverage.stop_tracking("draw particles")


func tick_particles(delta: float):
	for particle: WindPlatformerMinigameParticle in particles:
		particle.add_force(get_force_at(particle.position) * delta * 60)


func add_particle(pos: Vector2):
	var particle := WindPlatformerMinigameParticle.new()
	particle.position = pos
	particle.destroyed.connect(on_particle_destroyed.bind(particle))
	particles.append(particle)


func spawn_random_particle():
	add_particle(Vector2(randi() % size.x, randi() % size.y))


func on_particle_destroyed(particle: WindPlatformerMinigameParticle):
	particles.erase(particle)
	spawn_random_particle()


func get_force_at(pos: Vector2) -> Vector2:
	var noise: float = wind_noise.get_noise_2dv(pos)
	return Vector2.from_angle(wrapf(noise * 10.0, -PI, PI))


func _on_player_left_screen() -> void:
	if not disable_game_over:
		game_over()
