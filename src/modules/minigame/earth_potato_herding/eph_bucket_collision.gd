#- tools
#- classnames
class_name EPHBucketCollision
#- extends
extends Area2D
#- docstrings
#- signals
#- enums
#- consts
const DEFAULT_TIME_TO_GROW: float = 30.0
#- staticvars
#- exports
@export var bucket: Sprite2D
@export var stones: AnimatedSprite2D
@export var text: RichTextLabel

#- pubvars
#- prvvars
var minigame: EarthPotatoHerdingMinigame
var _time := 1.0
var _total_time
var _purple_frames := 5
#- onreadypubvars
#- onreadyprvvars
#- others


func is_it_a_demon(body: Node2D) -> void:
	if is_instance_of(body, EphEvilSprit):
		var spirit: EphEvilSprit = body
		spirit.ungrab_youngling()


func _process(delta: float) -> void:
	_time += delta
	if _time <= _total_time:
		stones.frame = 0 + floor((_time / _total_time) * _purple_frames)
		text.text = "Protect the younglings!"
	else:
		stones.frame = _purple_frames
		text.text = "Harvesting." + ".".repeat(int(_time * 3) % 3)


func _start_effect():
	self._time = 0.0
	self._total_time = minigame.get_potato_growth_time()


func _ready() -> void:
	text.text = ""
	minigame = get_tree().get_first_node_in_group("earth_potato_herding")
	minigame.game_started.connect(_start_effect)
