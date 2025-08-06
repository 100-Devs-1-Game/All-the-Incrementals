# A script meant to manage Insects that are animated via blend shapes and move procedurally

extends Node3D

@export_group("Insect Manager")
@export var animated: bool = false
@warning_ignore("shadowed_global_identifier") @export var custom_seed: float = 0.0
@export var blend_shape_count: int = 4
@export var mesh_path: NodePath
@export var spawn_area: Node3D
@export var no_spawn_area: Node3D
@export var insect_scene_path: String
@export var insect_node_name: String
@export var spawn_count: int = 3
@export var proximity_threshold: float = 0.1

var seed_internal: float = 0.0  # FIXED: declare it
var seed: float:
	get:
		return seed_internal
	set(value):
		seed_internal = value
		for mesh in target_meshes:
			randomize_with_seed(value, mesh)

var insect_instances: Array = []
var target_meshes: Array = []
var idle_timers: Dictionary = {}
var move_directions: Dictionary = {}
var rng := RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	print("READY: Attempting to spawn ", spawn_count, " insects.")
	for i in spawn_count:
		spawn_insect()
	print("Spawned insects: ", insect_instances.size())


func _process(delta):
	for i in insect_instances.size():
		var insect = insect_instances[i]
		if not idle_timers.has(insect):
			idle_timers[insect] = rand_idle_time()
			move_directions[insect] = rand_dir()

		idle_timers[insect] -= delta
		if idle_timers[insect] > 0.0:
			continue

		var dir = move_directions[insect]
		insect.translate(dir * delta)

		if rng.randf() < 0.01:
			idle_timers[insect] = rand_idle_time()
			move_directions[insect] = rand_dir()

	if animated:
		for mesh in target_meshes:
			randomize_with_seed(seed + Time.get_ticks_msec() * 0.001, mesh)


func rand_idle_time():
	return rng.randf_range(0.3, 2.0)


func rand_dir():
	var angle = rng.randf_range(0.0, TAU)
	return Vector3(cos(angle), 0, sin(angle)) * 0.5


func randomize_with_seed(s, mesh):
	if not mesh:
		return
	var local_rng = RandomNumberGenerator.new()
	local_rng.seed = int(s * 10000.0) % 2147483647
	for i in blend_shape_count:
		mesh.set_blend_shape_value(i, local_rng.randf())


func spawn_insect():
	if insect_scene_path == "" or spawn_area == null:
		print("ERROR: Insect scene path is empty or spawn_area is null.")
		return

	var packed_scene: PackedScene = load(insect_scene_path)
	if packed_scene == null:
		print("ERROR: Could not load insect scene: ", insect_scene_path)
		return

	var wrapper = packed_scene.instantiate()
	if not wrapper.has_node(insect_node_name):
		print("ERROR: Wrapper doesn't have node: ", insect_node_name)
		return

	var insect = wrapper.get_node(insect_node_name)
	if insect == null:
		print("ERROR: Could not get insect node from wrapper.")
		return

		wrapper.remove_child(insect)
		insect.owner = null
		call_deferred("add_child", insect)
		insect_instances.append(insect)

	if spawn_area == null or no_spawn_area == null:
		print("ERROR: Spawn area or no spawn area is null.")
		return

	var aabb = spawn_area.get_mesh().get_aabb()
	var origin = spawn_area.global_transform.origin
	var basis = spawn_area.global_transform.basis
	var spawn_box = AABB(
		origin + basis.x * aabb.position.x + basis.y * aabb.position.y + basis.z * aabb.position.z,
		basis.x * aabb.size.x + basis.y * aabb.size.y + basis.z * aabb.size.z
	)
	var exclude_box = no_spawn_area.get_mesh().get_aabb().transformed(
		no_spawn_area.global_transform
	)

	var tries := 100
	while tries > 0:
		var pos = Vector3(
			rng.randf_range(spawn_box.position.x, spawn_box.position.x + spawn_box.size.x),
			rng.randf_range(spawn_box.position.y, spawn_box.position.y + spawn_box.size.y),
			rng.randf_range(spawn_box.position.z, spawn_box.position.z + spawn_box.size.z)
		)
		if not exclude_box.has_point(pos):
			insect.global_position = pos
			break
		tries -= 1

	var mesh = insect.get_node_or_null(mesh_path)
	if mesh:
		target_meshes.append(mesh)
	else:
		print("WARNING: Couldn't find mesh with path: ", mesh_path)
