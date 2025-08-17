class_name WaterRowingRapidsMinigame
extends BaseMinigame

const SPIRITS: Array[PackedScene] = [
	preload("uid://bam250ejn756g"),  # regular
	preload("uid://dyf4vi3kcgp0i"),  # medium
	preload("uid://c2e6sovjs2632"),  # large
	preload("uid://b6ar87nw0ggf4")  # huge
]

## influences what spirits can spawn
@export var spirit_value: float = 1.0

@onready var player: RigidBody2D = $RowingPlayer
@onready var chase_void: Area2D = $Void
@onready var soul_spawner: WRRSoulSpawner = %SoulSpawner


func _initialize():
	var river_polygon: PackedVector2Array = $River.curve.get_baked_points()
	$River/Bank.points = river_polygon
	var water: Polygon2D = %Wadder
	water.polygon = river_polygon
	%RiverCollider.shape.segments = polyline_to_segments(river_polygon)
	water.texture_scale = Vector2.ONE * 537.0 / 1000.0  # don't ask
	EventBus.request_music.emit(&"rowing_rapids")
	chase_void.player = player


func _start():
	soul_spawner.regenerate_all()
	soul_spawner.on_every_point(
		func(spawner: WRRSoulSpawner, point: Vector2):
			var spirit_inst := SPIRITS[choose_spirit()].instantiate()
			add_child(spirit_inst)
			spirit_inst.global_position = spawner.get_point_global_pos(point)
	)


func choose_spirit() -> int:
	var choice := clampi(
		floori((1 - spirit_value / float(len(SPIRITS) + 1)) ** (randf() * -1) - 1), 0, len(SPIRITS)
	)
	return choice


func _on_rowing_player_spirit_collected(value: int) -> void:
	add_score(value)
	chase_void.repel()


func polyline_to_segments(polyline: PackedVector2Array) -> PackedVector2Array:
	var constructed: PackedVector2Array = []
	constructed.resize(len(polyline) * 2 - 2)
	for i in len(polyline) - 1:
		constructed[i * 2] = polyline[i]
		constructed[i * 2 + 1] = polyline[i + 1]
	return constructed
