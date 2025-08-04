extends Node2D

var base_width = 220.0
var base_upgrade_increment = 60.0

var col_shape: CollisionShape2D
var polygon: Polygon2D

func _ready() -> void:
	col_shape = $StaticBody2D/CollisionShape2D
	polygon = $Polygon2D

func _process(_delta):
	var rect_shape = col_shape.shape as RectangleShape2D
	if rect_shape:
		var extents = rect_shape.extents
		polygon.polygon = [
			Vector2(-extents.x, -extents.y),
			Vector2(extents.x, -extents.y),
			Vector2(extents.x, extents.y),
			Vector2(-extents.x, extents.y)
		]


func _upgrade():
	pass
