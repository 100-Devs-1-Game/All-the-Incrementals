@tool
extends Node2D

## 0-1 scale indicating "intensity"
@export_range(0, 1, 0.1) var intensity: float = 1.0:
	set(new):
		intensity = clampf(new, 0, 1)
		_update_all()

@export_subgroup("Scale Settings")
@export var scale_ratio: Vector2 = Vector2(1.0, 0.5):
	set(new):
		scale_ratio = new
		_update_scaling()

@export var scale_curve: Curve:
	set(new):
		if is_instance_valid(scale_curve):
			scale_curve.changed.disconnect(_update_scaling)
		scale_curve = new
		if is_instance_valid(alpha_curve):
			scale_curve.changed.connect(_update_scaling)
		_update_scaling()

@export var alpha_curve: Curve:
	set(new):
		if is_instance_valid(alpha_curve):
			alpha_curve.changed.disconnect(_update_alpha)
		alpha_curve = new
		if is_instance_valid(alpha_curve):
			alpha_curve.changed.connect(_update_alpha)
		_update_alpha()


func _update_all() -> void:
	_update_scaling()
	_update_alpha()


func _update_scaling() -> void:
	var sampled_intensity: float = intensity
	if is_instance_valid(scale_curve):
		sampled_intensity = scale_curve.sample(intensity)
	scale = Vector2.ONE - scale_ratio * (1 - sampled_intensity)


func _update_alpha() -> void:
	if not is_instance_valid(alpha_curve):
		modulate.a = 1.0
		return
	modulate.a = alpha_curve.sample(intensity)
