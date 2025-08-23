extends Node3D

# ─────────────────────────────────────
# ▌ Position
# ─────────────────────────────────────
@export_group("Position")
@export var enable_position := false
@export var position_speed := 1.0
@export var position_amplitude := 1.0
@export var position_axis_x := false
@export var position_axis_y := false
@export var position_axis_z := false

# ─────────────────────────────────────
# ▌ Rotation (pivot-safe)
# ─────────────────────────────────────
@export_group("Rotation")
@export var enable_rotation := false
@export var rotation_speed_deg := 90.0
@export var rotate_x_axis := false
@export var rotate_y_axis := false
@export var rotate_z_axis := false
@export var custom_axis := Vector3.ZERO  # optional; if non-zero, overrides the booleans

# ─────────────────────────────────────
# ▌ Scale
# ─────────────────────────────────────
@export_group("Scale")
@export var enable_scale := false
@export var scale_speed := 1.0
@export var scale_amplitude := 0.2
@export var scale_uniform := true
@export var scale_axis_x := false
@export var scale_axis_y := false
@export var scale_axis_z := false

# ─────────────────────────────────────
# ▌ Light Flicker
# ─────────────────────────────────────
@export_group("Light Flicker")
@export var enable_light_flicker := false
@export var base_energy := 5.0
@export var flicker_amplitude := 1.0
@export var flicker_speed := 1.5
@export var flicker_offset := 0.0

# ─────────────────────────────────────
# ▌ Sway (adds a small extra rotation around local X)
# ─────────────────────────────────────
@export_group("Sway")
@export var enable_sway := false
@export var sway_amount := 5.0  # degrees peak
@export var sway_speed := 0.5

# ─────────────────────────────────────
# ▌ Bobbing
# ─────────────────────────────────────
@export_group("Bobbing")
@export var enable_bobbing := false
@export var bob_speed := 1.25
@export var bob_amplitude := 0.056

# ─────────────────────────────────────
# ▌ Wave (mesh deform)
# ─────────────────────────────────────
@export_group("Wave")
@export var enable_wave := false
@export var wave_strength := 0.1
@export var wave_speed := 2.0
@export var wave_y_top := 1.0
@export var wave_y_bottom := -1.0

var initial_rotation_degrees: Vector3
var noise := FastNoiseLite.new()

var base_mesh: ArrayMesh
var base_vertices: PackedVector3Array = PackedVector3Array()

var _time := 0.0
var _sway_t := 0.0
var _angle := 0.0

var _t0: Transform3D  # original transform
var _b0: Basis  # original orthonormal basis (rotation only)
var _s0: Vector3  # original local scale
var _p0: Vector3  # original local position


func _ready():
	_t0 = transform
	_b0 = _t0.basis.orthonormalized()
	_s0 = _t0.basis.get_scale()
	_p0 = _t0.origin
	initial_rotation_degrees = rotation_degrees

	noise.seed = randi()
	noise.frequency = 0.1

	if enable_wave:
		base_mesh = self.get("mesh") as ArrayMesh
		if base_mesh and base_mesh.get_surface_count() > 0:
			var surface := base_mesh.surface_get_arrays(0)
			base_vertices = surface[Mesh.ARRAY_VERTEX] as PackedVector3Array
		else:
			push_warning("Wave: no valid mesh/surface found.")


func _physics_process(delta: float) -> void:
	_time += delta

	# 1) Build a rotation around a stable axis
	var axis := _pick_axis()
	var rot_basis := _b0
	if enable_rotation:
		_angle = wrapf(_angle + deg_to_rad(rotation_speed_deg) * delta, 0.0, TAU)
		var r := Basis(axis, _angle)  # rotate around local axis
		rot_basis = r * _b0  # apply on top of original rotation

	# 2) Optional sway (small extra rotation around local X)
	if enable_sway:
		_sway_t += delta * sway_speed
		var sway_deg := noise.get_noise_1d(_sway_t) * sway_amount
		var sway_r := Basis(Vector3.RIGHT, deg_to_rad(sway_deg))
		rot_basis = sway_r * rot_basis

	# 3) Start with original position
	var pos := _p0

	# 4) Bobbing (local Y offset)
	if enable_bobbing:
		pos.y += sin(_time * bob_speed) * bob_amplitude

	# 5) Sinusoidal position offsets per-axis
	if enable_position:
		var pos_offset := sin(_time * position_speed) * position_amplitude
		if position_axis_x:
			pos.x += pos_offset
		if position_axis_y:
			pos.y += pos_offset
		if position_axis_z:
			pos.z += pos_offset

	# 6) Scale (relative to original scale)
	var scl := _s0
	if enable_scale:
		var f := 1.0 + sin(_time * scale_speed) * scale_amplitude
		if scale_uniform:
			scl = _s0 * f
		else:
			if scale_axis_x:
				scl.x = _s0.x * f
			if scale_axis_y:
				scl.y = _s0.y * f
			if scale_axis_z:
				scl.z = _s0.z * f

	# 7) Compose final transform from original pieces (no incremental drift)
	var final_basis := rot_basis.scaled(scl)
	transform = Transform3D(final_basis, pos)

	# 8) Light flicker
	if enable_light_flicker:
		var t = Time.get_ticks_msec() / 1000.0 + flicker_offset
		var flicker := base_energy + sin(t * flicker_speed) * flicker_amplitude
		if "light_energy" in self:
			self.light_energy = flicker
		elif "energy" in self:
			self.energy = flicker

	# 9) Wave deform (your original mesh code)
	if enable_wave and base_mesh and not base_vertices.is_empty():
		var tt := Time.get_ticks_msec() / 1000.0
		var new_vertices := PackedVector3Array()
		new_vertices.resize(base_vertices.size())
		for i in base_vertices.size():
			var v := base_vertices[i]
			var mask := pow(smoothstep(wave_y_top, wave_y_bottom, v.y), 2.0)
			var sway := sin(tt * wave_speed + v.y * 4.0) * wave_strength * mask
			new_vertices[i] = Vector3(v.x + sway, v.y, v.z)

		var arrays := base_mesh.surface_get_arrays(0)
		arrays[Mesh.ARRAY_VERTEX] = new_vertices

		var updated := ArrayMesh.new()
		updated.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		self.set("mesh", updated)


func _pick_axis() -> Vector3:
	if custom_axis != Vector3.ZERO:
		return custom_axis.normalized()

	var ax := 1.0 if rotate_x_axis else 0.0
	var ay := 1.0 if rotate_y_axis else 0.0
	var az := 1.0 if rotate_z_axis else 0.0
	var a := Vector3(ax, ay, az)

	if a == Vector3.ZERO:
		a = Vector3.UP
	return a.normalized()
