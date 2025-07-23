extends "res://addons/gut/test.gd"


func test_debug_draw_valid() -> void:
	# if it runs, good enough for us to be sure the addon is available and callable
	DebugDraw3D.clear_all()
	assert_has_method(DebugDraw3D, "draw_arrow")
