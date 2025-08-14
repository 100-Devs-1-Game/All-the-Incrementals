class_name WTFParallaxSpawner
extends Node2D

@export var scene: PackedScene
@export var target: Node
@export var delay: float = 1

var _next_delay: float
var _timer: float = 0


func _ready() -> void:
	if !target:
		target = get_parent()

	_next_delay = randf_range(delay * 0.4, delay * 1.6)


func _physics_process(delta: float) -> void:
	_timer += delta
	if _timer > _next_delay:
		var ok := _spawn()
		if ok:
			_timer = 0  # remove any leftover
			_next_delay = randf_range(delay * 0.4, delay * 1.6)


func _spawn() -> bool:
	var data: WTFParallaxData = WTFGlobals.minigame.parallax_db.get_data().values().pick_random()
	var min_y := data.spawn.get_spawn_height_range().x
	var max_y := data.spawn.get_spawn_height_range().y
	var y := randf_range(WTFGlobals.camera.get_top(), WTFGlobals.camera.get_bottom())
	if y < min_y || y > max_y:
		return false

	var inst := scene.instantiate()
	inst.global_position = Vector2(WTFGlobals.camera.get_right() + 256, y)
	target.add_child(inst)
	reset_physics_interpolation()

	return true
