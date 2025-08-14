extends Parallax2D

# To emulate the same behaviour used by Camera2D in The Monster Function below.
static var viewport_size_cached: Vector2 = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height"),
)

@warning_ignore("native_method_override")  # Override native implementation for hidden "virtual"
# _camera_moved. Works because this method is not called natively but insead duck-called on all
# members of a hidden group, the name of which is
# `"__cameras_" + String.num_int64(get_viewport().get_viewport_rid().get_id())`. We do this because
# Parallax2D does not account for camera zoom(!!) and I want to pinch this as close to the root
# as I POSSIBLY can.
func _camera_moved(
	_transform: Transform2D, _screen_pos: Vector2, _adjusted_screen_pos: Vector2
) -> void:
	var camera: Camera2D = get_viewport().get_camera_2d()
	# TODO: This information could be derived from _adjusted_screen_pos position and
	# viewport_size_cached....
	var zoom_corrected_position = (
		camera.get_screen_center_position() - viewport_size_cached / 2 / camera.zoom
	)

	screen_offset = zoom_corrected_position
