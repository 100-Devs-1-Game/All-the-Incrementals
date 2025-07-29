extends Node2D

var _splash_utils: SplashUtils = preload("res://modules/main/splash_utils.gd").new()
var _splash_duration: float = 2.0  # seconds
var _splash_screens = ["res://modules/main/splash_one.tscn", "res://modules/main/splash_two.tscn"]


func _ready():
	print("Game started")
	_set_black_clear_color()
	_start_splash_screens()


# This helps will making transitions between scenes not flicker as much
func _set_black_clear_color() -> void:
	print("Setting clear color to black")
	RenderingServer.set_default_clear_color(Color.BLACK)


func _start_splash_screens() -> void:
	# only add child after current node tree is ready
	await get_tree().process_frame

	for file in _splash_screens:
		var splash: Node = load(file).instantiate()
		splash.modulate.a = 0.0  # invisible at start
		get_tree().root.add_child(splash)

		await _splash_utils.fade_in_scene(splash, _splash_duration)
		await _splash_utils.fade_out_scene(splash, _splash_duration)
		splash.queue_free()

	get_tree().change_scene_to_file("res://modules/menu/main_menu.tscn")
