#- tools
#- classnames
class_name EPHBucketCollision
#- extends
extends Area2D
#- docstrings
#- signals
#- enums
#- consts
#- staticvars
#- exports
@export var bucket: Sprite2D
@export var stones: AnimatedSprite2D
@export var text: RichTextLabel

#- pubvars
#- prvvars

var _time := 1.0
var _total_time := 60.0
var _purple_frames := 6
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


func start_effect(total_time: float):
	assert(bucket)
	assert(text)
	self._time = 0.0
	self._total_time = total_time
