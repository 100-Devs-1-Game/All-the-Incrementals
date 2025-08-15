class_name WTFBoatSpawner
extends Node2D

@export var scene: PackedScene
@export var target: Node
@export var delay: float = 10

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
	if !WTFGlobals.minigame.stats.spawn_boats:
		queue_free()
		return false

	var min_y := WTFConstants.SEALEVEL - (WTFGlobals.camera.get_visible_rect().size.y * 2)
	var max_y := WTFConstants.SEALEVEL - 200
	var y := randf_range(min_y, max_y)
	if y < WTFGlobals.camera.get_top() || y > WTFGlobals.camera.get_bottom():
		return false

	var inst := scene.instantiate()
	inst.global_position = Vector2(
		WTFGlobals.camera.get_right() + randf_range(0, WTFGlobals.camera.get_visible_rect().size.x),
		y
	)

	target.add_child(inst)
	inst.reset_physics_interpolation()

	return true
