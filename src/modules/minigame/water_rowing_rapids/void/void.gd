extends Node2D

@export var volume_fadeout: Curve

var player: Node2D

var speed: float = 300.0

@onready var whispers: AudioStreamPlayer = $Whispers


func _ready() -> void:
	volume_fadeout.bake()


func _process(_delta: float) -> void:
	var distance := maxf(player.position.x, position.x) - position.x
	var fade := volume_fadeout.sample_baked(distance)
	Music._music_player.volume_linear = fade
	whispers.volume_linear = 1.0 - fade


func _physics_process(delta: float) -> void:
	position.x += speed * delta
