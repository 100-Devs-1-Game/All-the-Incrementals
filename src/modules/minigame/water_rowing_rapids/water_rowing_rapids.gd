class_name WaterRowingRapidsMinigame
extends BaseMinigame


func _initialize():
	var river_polygon: PackedVector2Array = $River.curve.get_baked_points()
	var water: Polygon2D = $Wadder
	water.polygon = river_polygon
	water.texture_scale = Vector2.ONE * 50.0 / 1000.0


func _start():
	pass


func _on_rowing_player_spirit_collected(value: int) -> void:
	add_score(value)
