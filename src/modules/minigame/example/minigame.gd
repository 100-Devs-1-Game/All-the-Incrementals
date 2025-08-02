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
	circle_center.rotate(rotation_speed * delta)


func on_upgrade_button_pressed(upgrade: MinigameUpgrade):
	upgrade.level_up()
	upgrade.logic._apply_effect(self, upgrade)
