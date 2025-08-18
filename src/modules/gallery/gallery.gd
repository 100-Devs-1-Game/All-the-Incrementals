extends Node3D

enum CARD { L3, L2, L1, C, R1, R2, R3 }

@export var extras: PackedScene
@export var _overlay: CanvasLayer
@export var _overlay_bg: ColorRect
@export var _overlay_image: TextureRect

var _slot_rotations: Dictionary = {}
var _slot_positions: Dictionary = {}
var _card_at_slot: Dictionary = {}
var _is_rotating: bool = false
var _rotate_delay: float = 0.2
var _art: Array[String] = []
var _random_starting_point: int  # L3 image
var _current_position: int  # L3 image


func _ready() -> void:
	_card_at_slot[CARD.L3] = $ImageL3  # Off screen (invisible)
	_card_at_slot[CARD.L2] = $ImageL2
	_card_at_slot[CARD.L1] = $ImageL1
	_card_at_slot[CARD.C] = $ImageCenter
	_card_at_slot[CARD.R1] = $ImageR1
	_card_at_slot[CARD.R2] = $ImageR2
	_card_at_slot[CARD.R3] = $ImageR3  # Off screen (invisible)

	_slot_rotations[CARD.L3] = $ImageL3.rotation
	_slot_rotations[CARD.L2] = $ImageL2.rotation
	_slot_rotations[CARD.L1] = $ImageL1.rotation
	_slot_rotations[CARD.C] = $ImageCenter.rotation
	_slot_rotations[CARD.R1] = $ImageR1.rotation
	_slot_rotations[CARD.R2] = $ImageR2.rotation
	_slot_rotations[CARD.R3] = $ImageR3.rotation

	_slot_positions[CARD.L3] = $ImageL3.position
	_slot_positions[CARD.L2] = $ImageL2.position
	_slot_positions[CARD.L1] = $ImageL1.position
	_slot_positions[CARD.C] = $ImageCenter.position
	_slot_positions[CARD.R1] = $ImageR1.position
	_slot_positions[CARD.R2] = $ImageR2.position
	_slot_positions[CARD.R3] = $ImageR3.position

	_art = get_shuffled_gallery_images()

	_random_starting_point = randi() % _art.size()
	_current_position = _random_starting_point
	$CanvasLayer/Left.pressed.connect(rotate_left)
	$CanvasLayer/Right.pressed.connect(rotate_right)
	$CanvasLayer/HBoxContainer/Back.pressed.connect(SceneLoader.enter_extras)
	$CanvasLayer/HBoxContainer/Full.pressed.connect(fullscreen_art)
	init_cards()
	_init_fullscreen_overlay()


func init_cards() -> void:
	var i = _random_starting_point

	var material: StandardMaterial3D

	var card_order = [CARD.L3, CARD.L2, CARD.L1, CARD.C, CARD.R1, CARD.R2, CARD.R3]

	for spot in card_order.size():
		material = _card_at_slot[spot].get_surface_override_material(0)
		material.albedo_texture = load(_art[i % _art.size()])
		i += 1


func rotate_left() -> void:
	if _is_rotating:
		return
	_is_rotating = true
	var tween = get_tree().create_tween()

	var card_order = [CARD.L3, CARD.L2, CARD.L1, CARD.C, CARD.R1, CARD.R2, CARD.R3]
	for i in card_order.size() - 1:
		var from = card_order[i]
		var to = card_order[i + 1]  # where it's moving to
		tween.parallel().tween_property(
			_card_at_slot[from], "position", _slot_positions[to], _rotate_delay
		)
		tween.parallel().tween_property(
			_card_at_slot[from], "rotation", _slot_rotations[to], _rotate_delay
		)

	await tween.finished

	_card_at_slot[CARD.R3].queue_free()
	_card_at_slot[CARD.R3] = _card_at_slot[CARD.R2]
	_card_at_slot[CARD.R2] = _card_at_slot[CARD.R1]
	_card_at_slot[CARD.R1] = _card_at_slot[CARD.C]
	_card_at_slot[CARD.C] = _card_at_slot[CARD.L1]
	_card_at_slot[CARD.L1] = _card_at_slot[CARD.L2]
	_card_at_slot[CARD.L2] = _card_at_slot[CARD.L3]

	_current_position -= 1
	var index = _current_position % _art.size()
	var new_mesh_instance: MeshInstance3D = _create_card(index)
	add_child(new_mesh_instance)
	new_mesh_instance.rotation = _slot_rotations[CARD.L3]
	new_mesh_instance.position = _slot_positions[CARD.L3]
	_card_at_slot[CARD.L3] = new_mesh_instance

	_is_rotating = false


func _create_card(index: int) -> MeshInstance3D:
	var new_mesh_instance = MeshInstance3D.new()
	var new_plane_mesh = PlaneMesh.new()
	new_mesh_instance.mesh = new_plane_mesh
	var new_standard_material_3d = StandardMaterial3D.new()
	var new_card_at_slot_texture = load(_art[index])
	new_standard_material_3d.albedo_texture = new_card_at_slot_texture
	new_mesh_instance.set_surface_override_material(0, new_standard_material_3d)
	new_mesh_instance.scale = Vector3(1.5, 1.5, 1.5)

	return new_mesh_instance


func _init_fullscreen_overlay() -> void:
	_overlay.visible = false
	if not _overlay_bg.is_connected("gui_input", _on_overlay_bg_gui_input):
		_overlay_bg.gui_input.connect(_on_overlay_bg_gui_input)


func fullscreen_art() -> void:
	if _is_rotating:
		return

	if _overlay == null or _overlay_image == null or not _card_at_slot.has(CARD.C):
		return

	var mesh = _card_at_slot[CARD.C]
	var mat = null
	var std_mat = null

	if mesh:
		mat = mesh.get_surface_override_material(0)
	if mat:
		std_mat = mat as StandardMaterial3D

	if mesh == null or mat == null or std_mat == null or std_mat.albedo_texture == null:
		return

	_overlay_image.texture = std_mat.albedo_texture
	_overlay.visible = true


func _close_fullscreen() -> void:
	if _overlay:
		_overlay.visible = false


func _on_overlay_bg_gui_input(event: InputEvent) -> void:
	# Close on any mouse click when visible
	if _overlay and _overlay.visible and event is InputEventMouseButton:
		var mb = event as InputEventMouseButton
		if mb.pressed:
			_close_fullscreen()


func rotate_right() -> void:
	if _is_rotating:
		return
	_is_rotating = true
	var tween = get_tree().create_tween()

	var card_order = [CARD.R3, CARD.R2, CARD.R1, CARD.C, CARD.L1, CARD.L2, CARD.L3]
	for i in card_order.size() - 1:
		var from = card_order[i]
		var to = card_order[i + 1]  # where it's moving to
		tween.parallel().tween_property(
			_card_at_slot[from], "position", _slot_positions[to], _rotate_delay
		)
		tween.parallel().tween_property(
			_card_at_slot[from], "rotation", _slot_rotations[to], _rotate_delay
		)

	await tween.finished

	_card_at_slot[CARD.L3].queue_free()
	_card_at_slot[CARD.L3] = _card_at_slot[CARD.L2]
	_card_at_slot[CARD.L2] = _card_at_slot[CARD.L1]
	_card_at_slot[CARD.L1] = _card_at_slot[CARD.C]
	_card_at_slot[CARD.C] = _card_at_slot[CARD.R1]
	_card_at_slot[CARD.R1] = _card_at_slot[CARD.R2]
	_card_at_slot[CARD.R2] = _card_at_slot[CARD.R3]

	_current_position += 1
	var index = (_current_position + 6) % _art.size()
	var new_mesh_instance: MeshInstance3D = _create_card(index)
	add_child(new_mesh_instance)
	new_mesh_instance.rotation = _slot_rotations[CARD.R3]
	new_mesh_instance.position = _slot_positions[CARD.R3]
	_card_at_slot[CARD.R3] = new_mesh_instance

	_is_rotating = false


func _input(event: InputEvent) -> void:
	if _overlay and _overlay.visible:
		if event.is_action_pressed("exit_menu"):
			_close_fullscreen()
			return
		if event is InputEventMouseButton:
			var mb = event as InputEventMouseButton
			if mb.pressed:
				_close_fullscreen()
				return
		return

	if event.is_action_pressed("exit_menu"):
		SceneLoader.enter_extras()
	elif event.is_action_pressed("left"):
		rotate_left()
	elif event.is_action_pressed("right"):
		rotate_right()
	elif event.is_action_pressed("primary_action"):
		print("Fullscreen image")
		fullscreen_art()


func quit_game() -> void:
	get_tree().quit()


func get_shuffled_gallery_images() -> Array[String]:
	var dir_path = "res://assets/gallery/"
	var file_list: Array[String] = []
	var valid_extensions = [".png", ".jpg", ".webp"]

	var dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				for ext in valid_extensions:
					if file_name.to_lower().ends_with(ext):
						file_list.append(dir_path + file_name)
						break
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("Failed to open directory: %s" % dir_path)

	file_list.shuffle()
	return file_list
