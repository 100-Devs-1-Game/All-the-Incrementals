class_name ExampleMinigame
extends BaseMinigame

const BRANCH_COLORS = [Color.GREEN, Color.ORANGE]

var rotation_speed: float = 1.0

@onready var hbox: HBoxContainer = %HBoxContainer
@onready var circle_center: Node2D = $"Circle Center"


func _init() -> void:
	set_process(false)


func _start() -> void:
	set_process(true)


func _process(delta: float) -> void:
	var prev_rotation: float = circle_center.rotation
	circle_center.rotate(rotation_speed * delta)
	if int(circle_center.rotation / PI) != int(prev_rotation / PI):
		add_score(1)


func _get_countdown_duration() -> float:
	return 20
