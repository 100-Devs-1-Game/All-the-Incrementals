class_name FireFightersMinigameMapGenerator


static func generate_map(
	rect: Rect2i,
	tile_map_terrain: TileMapLayer,
	tile_map_objects: TileMapLayer,
	map_features: Array[FireFightersMinigameMapFeature]
):
	for x in range(rect.position.x, rect.position.x + rect.size.x):
		for y in range(rect.position.y, rect.position.y + rect.size.y):
			var tile := Vector2i(x, y)

			if randf() < 0.2:
				tile_map_terrain.set_cell(tile, 0, Vector2i([0, 1].pick_random(), 0))

			var feature: FireFightersMinigameMapFeature = get_feature_at(tile, map_features)
			if feature:
				tile_map_objects.set_cell(tile, 0, feature.atlas_coords)


static func get_feature_at(
	tile: Vector2i, map_features: Array[FireFightersMinigameMapFeature]
) -> FireFightersMinigameMapFeature:
	for feature in map_features:
		if feature.spawn_manually:
			continue
		if feature.density > randf():
			if not feature.spawn_noise:
				return feature
			if feature.spawn_noise.get_noise_2dv(tile) > feature.spawn_noise_threshold:
				return feature
	return null
