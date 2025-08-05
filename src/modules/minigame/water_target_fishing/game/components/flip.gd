class_name WTFFlip
extends Node2D

# used to flip left/right depending on movement
# notably for fish, this only considers the velocity from AI, not from waves

@export var target: Node2D
@export var velocity_component: WTFVelocityComponent
@export var reversed: bool = false

var flipped: bool = false
var initial_scale: float


func _ready() -> void:
	initial_scale = target.scale.x
	if reversed:
		initial_scale *= -1


func _physics_process(_delta: float) -> void:
	if velocity_component.velocity.x > 0:
		target.scale.x = initial_scale
	else:
		target.scale.x = -initial_scale
