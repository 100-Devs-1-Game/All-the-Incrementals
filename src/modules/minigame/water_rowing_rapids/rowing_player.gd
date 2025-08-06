extends Node2D

var boat_health: = 10
var boat_row_speed: = 85.0
var boat_ud_speed: = 20.0
var boat_speed_increase: = 45.0
var boat_stability: = 100.0
var boat_max_stability: = 100.0
var boat_stability_drain: = 8.0
var boat_speed_drain: = 1.0
var boat_speed_decrease: = 30.0
var boat_stability_regen: = 6.5

func _ready() -> void:
	$Polygon2D/Area2D.area_entered.connect(_boat_touched)

func _process(delta: float) -> void:
	global_position.x += boat_row_speed * delta
	if boat_row_speed > 85.0:
		boat_row_speed -= boat_speed_drain * delta
	if boat_row_speed > 300.0:
		boat_stability -= boat_stability_drain * delta
	elif boat_row_speed < 300.0 and boat_stability < boat_max_stability:
		boat_stability += boat_stability_regen * delta
	
	if Input.is_action_pressed("up"):
		global_position.y -= boat_ud_speed * delta
	elif Input.is_action_pressed("down"):
		global_position.y += boat_ud_speed * delta

func _boat_touched(area: Area2D):
	if area.is_in_group("hazzard"):
		_fail()

func _boost():
	boat_row_speed = boat_row_speed + boat_speed_increase

func _fail():
	boat_row_speed = clampf(boat_row_speed, 85.0, 1000.0)
	boat_row_speed = boat_row_speed - boat_speed_decrease
	boat_stability -= 10.0
