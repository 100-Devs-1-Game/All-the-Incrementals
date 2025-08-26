extends Node2D

@export var _splash_durations: Array[float] = []  # seconds
@export var _splash_screens: Array[String] = []

@export var main_menu: PackedScene

var _show_splash_screens = true
var _current_splash: Node

@onready var _splash_utils: SplashUtils = %SplashUtils


func _exit_tree() -> void:
	if is_instance_valid(_current_splash):
		_current_splash.queue_free()


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
		print("Skipping splash screens is disabled")
		return

		_show_splash_screens = false
		_load_main_menu()


func _start_splash_screens() -> void:
	if !is_inside_tree() or !_show_splash_screens:
		return

	assert(_splash_screens.size() == _splash_durations.size())

	for i in range(_splash_screens.size()):
		var file := _splash_screens[i]
		var splash_duration := _splash_durations[i]
		_current_splash = load(file).instantiate()
		add_child(_current_splash)

		if file != _splash_screens.front():
			#_current_splash.modulate.a = 0.0  # invisible at start
			await _splash_utils.fade_in_scene(_current_splash, splash_duration / 2.0)
		else:
			await get_tree().create_timer(splash_duration / 2.0).timeout

		if file != _splash_screens.back():
			await _splash_utils.fade_out_scene(_current_splash, splash_duration / 2.0)
			_current_splash.queue_free()
		else:
			await get_tree().create_timer(splash_duration / 2.0).timeout

	_load_main_menu()


func _load_main_menu() -> void:
	if !is_inside_tree():
		return

	await get_tree().process_frame  # prevent flicker
	get_tree().change_scene_to_packed(main_menu)
