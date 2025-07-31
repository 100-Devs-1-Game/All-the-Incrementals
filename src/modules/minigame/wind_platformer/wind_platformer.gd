class_name WindPlatformerMinigame
extends BaseMinigame

@export var wind_noise: FastNoiseLite
@export var size: Vector2i = Vector2i(2000, 1100)

@export var num_particles: int = 500

var wind_arr: Dictionary
var particles: Array[WindPlatformerMinigameParticle]

@onready var multi_mesh_instance: MultiMeshInstance2D = $MultiMeshInstance2D


func _ready() -> void:
	for i in num_particles:
		spawn_random_particle()


func _physics_process(delta: float) -> void:
	tick_particles(delta)


func tick_particles(delta: float):
	multi_mesh_instance.multimesh.instance_count = particles.size()
	var i := 0
	for particle: WindPlatformerMinigameParticle in particles:
		particle.add_force(get_force_at(particle.position))
		particle.tick(delta)
		multi_mesh_instance.multimesh.set_instance_transform_2d(
			i, Transform2D(0, particle.position)
		)
		i += 1


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
