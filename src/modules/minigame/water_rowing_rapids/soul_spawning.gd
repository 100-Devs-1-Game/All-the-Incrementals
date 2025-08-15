@tool
# Poisson Disk Sampling (Sebastian Lague-inspired, GDScript port)
extends Node2D

## The minimum distance between points
@export var radius: float = 100
## Area to generate points within.
@export var sample_size: Vector2 = Vector2(500, 500):
	set(new):
		sample_size = new
		if Engine.is_editor_hint():
			points.clear()
			queue_redraw()
## Attempts per spawn point
@export var samples: int = 30

@export_tool_button("Regenerate", "Reload") var _regenerate_poisson: Callable = func():
	points.clear()
	poisson_disk_implementation()

var rng := RandomNumberGenerator.new()

var cell_size: float
var grid: Array = []
var grid_width: int
var grid_height: int
var points: Array[Vector2] = []
var spawn_points: Array[Vector2] = []


func _ready() -> void:
	rng.randomize()
	poisson_disk_implementation()


func poisson_disk_implementation() -> void:
	# Calculate grid cell size and dimensions
	cell_size = radius / sqrt(2)
	grid_width = ceil(sample_size.x / cell_size)
	grid_height = ceil(sample_size.y / cell_size)

	# Initialize 2D grid
	grid.clear()
	for i in range(grid_width):
		grid.append([])
		for j in range(grid_height):
			grid[i].append(-1)  # -1 means empty

	# Add initial spawn point in the center
	var center := sample_size / 2
	spawn_points.append(center)
	points.append(center)

	var center_x := int(center.x / cell_size)
	var center_y := int(center.y / cell_size)
	grid[center_x][center_y] = 0

	# Main generation loop
	while spawn_points.size() > 0:
		var spawn_index = rng.randi_range(0, spawn_points.size() - 1)
		var spawn_center = spawn_points[spawn_index]
		var point_placed = false

		# Try to place a new point around the spawn center
		for _i in range(samples):
			var angle = rng.randf_range(0, TAU)
			var dir = Vector2(cos(angle), sin(angle))
			var candidate = spawn_center + dir * rng.randf_range(radius, 2 * radius)

			if is_valid(candidate):
				points.append(candidate)
				spawn_points.append(candidate)

				var cx = int(candidate.x / cell_size)
				var cy = int(candidate.y / cell_size)
				grid[cx][cy] = points.size() - 1

				point_placed = true
				break

		if not point_placed:
			spawn_points.remove_at(spawn_index)
	queue_redraw()


func is_valid(candidate: Vector2) -> bool:
	if not is_in_bounds(candidate):
		return false

	var cell_x = int(candidate.x / cell_size)
	var cell_y = int(candidate.y / cell_size)

	var start_x = max(0, cell_x - 2)
	var end_x = min(grid_width - 1, cell_x + 2)
	var start_y = max(0, cell_y - 2)
	var end_y = min(grid_height - 1, cell_y + 2)

	for i in range(start_x, end_x + 1):
		for j in range(start_y, end_y + 1):
			var index = grid[i][j]
			if index != -1:
				var dist = candidate.distance_to(points[index])
				if dist < radius:
					return false
	return true


func is_in_bounds(candidate: Vector2) -> bool:
	return (
		candidate.x >= 0
		and candidate.x <= sample_size.x
		and candidate.y >= 0
		and candidate.y <= sample_size.y
	)


func _draw():
	if not Engine.is_editor_hint():
		return
	draw_rect(Rect2(Vector2.ZERO, sample_size), Color.WHITE, false)
	for p in points:
		draw_circle(p, 8, Color.RED)
