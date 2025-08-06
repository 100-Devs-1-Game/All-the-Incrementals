extends Control

@onready var point = $Panel/Point
@onready var target_zone = $Panel/GoodZone

@export var move_speed: = 300.0
@export var max_speed: = 1000.0
var direction: = 1
var speed_increase: = 50.0
var miss_speed_value: = 150
var speed_drain: = 55.0
var updating_ui: = false

@export var player: Node
@export var stability_bar: TextureProgressBar

func _ready() -> void:
	if player == null:
		print("No player set, selecting parent")
		player = get_parent()
	if stability_bar == null:
		push_warning("No stability bar, select one in the properties!")
	else:
		updating_ui = true
	set_target_width()

func _process(delta):
	point.position.x += move_speed * direction * delta

	var bar_width = $Panel.size.x
	var marker_width = point.size.x
	if point.position.x <= 0 or point.position.x + marker_width >= bar_width:
		direction *= -1
		set_target_width()
	if move_speed > 300.0:
		move_speed -= speed_drain * delta
	if updating_ui:
		_updateUI()

func _updateUI():
	stability_bar.value = player.boat_stability
	stability_bar.max_value = player.boat_max_stability

func _input(event):
	if event.is_action_pressed("primary_action"):
		var marker_rect = point.get_global_rect()
		var target_rect = target_zone.get_global_rect()
		
		if marker_rect.intersects(target_rect):
			print("Hit!")
			move_speed = clampf(move_speed, 300.0, max_speed)
			move_speed += speed_increase
			set_target_width()
			set_target_position()
			player._boost()
			
		else:
			print("Miss!")
			player._fail()
			move_speed = clampf(move_speed, 300.0, max_speed)
			move_speed = move_speed - miss_speed_value

func set_target_position():
	var panel_width = $Panel.size.x
	var new_width = randf_range(30.0, 100)
	var max_x = panel_width - new_width
	var new_x = randf_range(0.0, max_x)
	target_zone.position.x = new_x

func set_target_width():
	var base_width = 100.0
	var min_width = 30.0
	var shrink_amount = 0.1
	
	var scaled_width = base_width - (move_speed - 300.0) * shrink_amount
	scaled_width = clamp(scaled_width, min_width, base_width)
	target_zone.size.x = scaled_width
