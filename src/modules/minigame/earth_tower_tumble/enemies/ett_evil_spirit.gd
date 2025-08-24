extends RigidBody2D

const BEHAVIOURS := ["push", "damage"]

@export var damage_amount := 5
@export var float_speed := 110.0
var behaviour: String
var grabbing := false
var target: Node2D

@onready var area: Area2D = $Area2D
@onready var collider: CollisionShape2D = $collider
@onready var poly: Polygon2D = $Polygon2D


func _ready() -> void:
	behaviour = BEHAVIOURS.pick_random()

	if behaviour == "push":
		collider.disabled = false
		poly.color = Color.PURPLE

	# Hook collisions to one handler
	area.area_entered.connect(_on_touch)
	area.body_entered.connect(_on_touch)


func _process(delta: float) -> void:
	if grabbing:
		return

	if target == null or not is_instance_valid(target):
		_pick_target()
		return

	_move_to_target(delta)


func _pick_target() -> void:
	var options := get_tree().get_nodes_in_group("block")
	if options.is_empty():
		queue_free()
		return
	target = options.pick_random()


func _move_to_target(delta: float) -> void:
	var dir := target.global_position - global_position
	if dir == Vector2.ZERO:
		return
	global_position += dir.normalized() * float_speed * delta


func _on_touch(other: Node) -> void:
	if other.is_in_group("potato"):
		queue_free()
	elif other.is_in_group("block"):
		if behaviour == "damage" and other.has_method("damage"):
			other.damage(damage_amount)
