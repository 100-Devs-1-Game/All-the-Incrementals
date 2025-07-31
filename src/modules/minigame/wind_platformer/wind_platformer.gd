class_name WindPlatformerMinigame
extends BaseMinigame

@export var particle_scene: PackedScene
@export var wind_noise: FastNoiseLite
@export var size: Vector2i = Vector2i(2000, 1100)

@export var num_particles: int = 500
@export var run_simulation: bool = false
@export var simulation_turns: int = 50

var wind_arr: Dictionary

@onready var particle_node = $Particles
@onready var wind_canvas: ColorRect = %"Wind Canvas"


func _ready() -> void:
	for i in num_particles:
		spawn_random_particle()

	if run_simulation:
		for i in simulation_turns:
			tick_particles(1.0)
			for particle: WindPlatformerMinigameParticle in particle_node.get_children():
				wind_arr[Vector2i(particle.position)] = i


func on_draw(colrect: ColorRect):
	if wind_arr.is_empty():
		return

	for x in colrect.size.x:
		for y in colrect.size.y:
			var pixel := Vector2i(x, y)
			if wind_arr.has(pixel):
				var col := Color.WHITE
				col.a = lerp(1.0, 0.0, wind_arr[pixel] * (1.0 / simulation_turns))
				colrect.draw_rect(Rect2(pixel, Vector2.ONE), col)


func _physics_process(delta: float) -> void:
	if not run_simulation:
		tick_particles(delta)


func tick_particles(delta: float):
	for particle: WindPlatformerMinigameParticle in particle_node.get_children():
		particle.add_force(get_force_at(particle.position))
		particle.tick(delta)


func add_particle(pos: Vector2):
	var particle: WindPlatformerMinigameParticle = particle_scene.instantiate()
	particle.position = pos
	particle.destroyed.connect(func(): spawn_random_particle())
	particle_node.add_child(particle)


func spawn_random_particle():
	add_particle(Vector2(randi() % size.x, randi() % size.y))


func get_force_at(pos: Vector2) -> Vector2:
	var noise: float = wind_noise.get_noise_2dv(pos)
	return Vector2.from_angle(wrapf(noise * 10.0, -PI, PI))
