extends Node2D

@onready var col = $StaticBody2D/CollisionShape2D
@onready var poly = $Polygon2D

var base_width_current := 284.0
var upgrade_width_increment := 64.0
var upgrade_speed := 15.0

var base_upgrading := false

func _ready():
	update_polygon()

func _process(delta: float) -> void:
	if base_upgrading:
		update_polygon()
		col.shape.size.x = lerp(col.shape.size.x, base_width_current, upgrade_speed * delta)
		if (base_width_current - col.shape.size.x) < 0.01:
			base_upgrading = false

func update_polygon():
	var rect_size = col.shape.extents * 2.0
	var w = rect_size.x / 2.0
	var h = rect_size.y / 2.0

	poly.polygon = PackedVector2Array([
		Vector2(-w, -h),
		Vector2(w, -h),
		Vector2(w, h),
		Vector2(-w, h),
	])

func upgrade_base():
	base_width_current += upgrade_width_increment
	base_upgrading = true
