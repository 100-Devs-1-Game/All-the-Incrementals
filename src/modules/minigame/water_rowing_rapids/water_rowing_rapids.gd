class_name WaterRowingRapidsMinigame
extends BaseMinigame


func _initialize():
	var river_polygon: PackedVector2Array = $River.curve.get_baked_points()
	var water: Polygon2D = %Wadder
	water.polygon = river_polygon
	%RiverCollider.shape.segments = polyline_to_segments(river_polygon)
	water.texture_scale = Vector2.ONE * 50.0 / 1000.0  # don't ask
	EventBus.request_music.emit(&"rowing_rapids")
	$Void.player = $RowingPlayer


func _start():
	pass


func _on_rowing_player_spirit_collected(value: int) -> void:
	add_score(value)


func polyline_to_segments(polyline: PackedVector2Array) -> PackedVector2Array:
	var constructed: PackedVector2Array = []
	constructed.resize(len(polyline) * 2 - 2)
	for i in len(polyline) - 1:
		constructed[i * 2] = polyline[i]
		constructed[i * 2 + 1] = polyline[i + 1]
	return constructed
