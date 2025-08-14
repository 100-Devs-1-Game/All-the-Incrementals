extends Area2D

@export var volume_fadeout: Curve
@export var rubberband: Curve

var player: Node2D

var speed: float = 700.0

@onready var whispers: AudioStreamPlayer = $Whispers


func _init() -> void:
	WaterRowingRapidsMinigameUpgradeLogic.multiregister_base(self, [&"speed"])


func _ready() -> void:
	volume_fadeout.bake()
	rubberband.bake()


func _process(_delta: float) -> void:
	var distance := get_distance()
	var fade := volume_fadeout.sample_baked(distance)
	Music._music_player.volume_linear = fade
	whispers.volume_linear = 1.0 - fade


func _physics_process(delta: float) -> void:
	var rubberbanded_speed = rubberband.sample_baked(get_distance()) * speed
	position.x += rubberbanded_speed * delta

	for player in get_overlapping_bodies():
		player.take_damage(delta * 20.0)


func get_distance() -> float:
	return maxf(player.position.x, position.x) - position.x
