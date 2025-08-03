extends Node2D

@export var _splash_duration: float = 1.8  # seconds
@export var _splash_screens: Array[String] = []

@export var main_menu: PackedScene

var _splash_utils: SplashUtils = preload("res://modules/main/splash_utils.gd").new()
var _show_splash_screens = true


func _ready():
	print("Game started")
	_set_black_clear_color()
	_start_splash_screens()


# This makes transitions between scenes not flicker as much
func _set_black_clear_color() -> void:
	print("Setting clear color to black")
	RenderingServer.set_default_clear_color(Color.BLACK)


func _input(event: InputEvent) -> void:
	if !is_inside_tree():
		return

	if (
		event is InputEventKey
		or event is InputEventMouseButton
		or event is InputEventJoypadButton
		or event is InputEventJoypadMotion
	):
		print("Skipping splash screens")
		_show_splash_screens = false
		_load_main_menu()


func _start_splash_screens() -> void:
	if !is_inside_tree() or !_show_splash_screens:
		return

	for file in _splash_screens:
		var splash: Node = load(file).instantiate()
		splash.modulate.a = 0.0  # invisible at start
		add_child(splash)
		await _splash_utils.fade_in_scene(splash, _splash_duration)
		await _splash_utils.fade_out_scene(splash, _splash_duration / 2)
		splash.queue_free()

	_load_main_menu()


func _load_main_menu() -> void:
	if !is_inside_tree():
		return
	get_tree().change_scene_to_packed(main_menu)
