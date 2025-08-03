class_name WTFSpawnData
extends Resource

# controls how spawn depth is read
enum SpawnType {
	SKY,  # can never go "below" sealevel
	SEALEVEL,  # always at sealevel, ignores min/max depth
	OCEAN,  # can never go "above" sealevel
}

@export var spawn_type := SpawnType.OCEAN

@export var min_spawn_distance: float
@export var _min_spawn_depth: float
@export var _max_spawn_depth: float


func get_spawn_height_range() -> Vector2:
	match spawn_type:
		SpawnType.SKY:
			return Vector2(min(WTFConstants.SEALEVEL, _min_spawn_depth), _max_spawn_depth)
		SpawnType.SEALEVEL:
			return Vector2.ZERO
		SpawnType.OCEAN:
			return Vector2(max(WTFConstants.SEALEVEL, _min_spawn_depth), _max_spawn_depth)
	push_error("oops, unhandled spawn type")
	assert(false)
	return Vector2.ZERO
