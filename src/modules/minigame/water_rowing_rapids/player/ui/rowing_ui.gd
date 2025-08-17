extends Control

@export var tick_base_move_speed := 300.0
@export var tick_speed_mod := 1.3
@export var tick_max_speed := 800.0
@export var boost_area_base_scale := 1.0
@export var player: Node
@export var stability_bar: TextureProgressBar

var tick_move_speed := tick_base_move_speed
var direction := 1
var updating_ui := false

@onready var point = %Point
@onready var target_zone = %GoodZone


func _ready() -> void:
	WaterRowingRapidsMinigameUpgradeLogic.multiregister_base(self, [&"boost_area_base_scale"])
	if player == null:
		print("No player set, selecting parent")
		player = get_parent()
	if stability_bar == null:
		push_warning("No stability bar, select one in the properties!")
	else:
		updating_ui = true
	set_target_width()


func _process(delta):
	point.position.x += tick_move_speed * direction * delta

	var bar_width = $Panel.size.x
	var marker_width = point.size.x
	if point.position.x + marker_width >= bar_width:
		point.position.x = 0
		target_zone.scale.x = boost_area_base_scale
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
			tick_move_speed = minf(tick_move_speed * tick_speed_mod, tick_max_speed)
			point.position.x = 0
			set_target_width()
			player._boost()

		else:
			print("Miss!")
			player._fail()
			target_zone.scale.x = boost_area_base_scale
			point.position.x = 0
			tick_move_speed = tick_base_move_speed


func set_target_width():
	var min_width: float = 0.3

	var scaled: float = (target_zone.scale.x - min_width) * 0.8
	target_zone.scale.x = scaled + min_width
