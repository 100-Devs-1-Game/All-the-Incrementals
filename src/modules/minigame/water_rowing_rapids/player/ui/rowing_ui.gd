extends Control

@export var move_speed := 300.0
@export var max_speed := 1000.0
@export var player: Node
@export var stability_bar: TextureProgressBar

var direction := 1
var speed_increase := 50.0
var miss_speed_value := 150
var speed_drain := 55.0
var updating_ui := false

@onready var point = %Point
@onready var target_zone = %GoodZone


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
	if point.position.x + marker_width >= bar_width:
		point.position.x = 0
		target_zone.scale.x = 1
	if move_speed > 300.0:
		move_speed -= speed_drain * delta
	if updating_ui:
		update_ui()


func update_ui():
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
			point.position.x = 0
			set_target_width()
			player._boost()

		else:
			print("Miss!")
			player._fail()
			target_zone.scale.x = 1
			point.position.x = 0
			move_speed = clampf(move_speed, 300.0, max_speed)
			move_speed = move_speed - miss_speed_value


func set_target_width():
	var min_width: float = 0.3

	var scaled: float = (target_zone.scale.x - min_width) * 0.8
	target_zone.scale.x = scaled + min_width
