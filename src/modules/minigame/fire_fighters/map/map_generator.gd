class_name FireFightersMinigameMapGenerator


static func generate_map(game: FireFightersMinigame):
	var rect: Rect2i = game.map_rect

	for x in range(rect.position.x, rect.position.x + rect.size.x):
		for y in range(rect.position.y, rect.position.y + rect.size.y):
			var tile := Vector2i(x, y)

			if rect.get_center().distance_to(tile) < 4:
				continue

			if randf() < 0.2:
				game.tile_map_terrain.set_cell(tile, 0, Vector2i([0, 1].pick_random(), 0))

			var feature: FireFightersMinigameMapFeature = get_feature_at(tile, game)
			if feature:
				game.tile_map_objects.set_cell(tile, 0, feature.atlas_coords)


static func get_feature_at(
	tile: Vector2i, game: FireFightersMinigame
) -> FireFightersMinigameMapFeature:
	for feature in game.map_features:
		if feature.spawn_manually:
			continue
		if feature.density > randf():
			if not feature.spawn_noise:
				return feature
			var threshold: float = feature.spawn_noise_threshold
			if game.reduce_map_feature_thresholds.has(feature):
				threshold -= game.reduce_map_feature_thresholds[feature]
			if feature.spawn_noise.get_noise_2dv(tile) > threshold:
				return feature
	return null
