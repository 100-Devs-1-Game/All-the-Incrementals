extends Node2D

@export var base_width_current := 64.0
@export var upgrade_width_increment := 64.0
@export var upgrade_speed := 15.0
@export var snap_threshold := 0.5

var base_upgrading := false

@onready var col: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var poly: Polygon2D = $Polygon2D
@onready var rect: RectangleShape2D = null

func _ready():
	rect = col.shape as RectangleShape2D
	if rect == null:
		rect = RectangleShape2D.new()
		col.shape = rect
	rect.size.x = base_width_current
	update_polygon()

func _process(delta: float) -> void:
	if base_upgrading:
		var t = clamp(upgrade_speed * delta, 0.0, 1.0)
		rect.size.x = lerp(rect.size.x, base_width_current, t)
		update_polygon()
		if abs(base_width_current - rect.size.x) <= snap_threshold:
			rect.size.x = base_width_current
			base_upgrading = false
			update_polygon()

func update_polygon():
	var half_w := rect.size.x * 0.5
	var half_h := rect.size.y * 0.5
	poly.polygon = PackedVector2Array([
		Vector2(-half_w, -half_h),
		Vector2( half_w, -half_h),
		Vector2( half_w,  half_h),
		Vector2(-half_w,  half_h),
	])

func upgrade_base():
	base_width_current += upgrade_width_increment
	base_upgrading = true
