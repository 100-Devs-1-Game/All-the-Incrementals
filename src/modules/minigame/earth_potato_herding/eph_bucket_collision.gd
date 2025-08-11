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
@export var timer: TextureProgressBar
@export var text: RichTextLabel

@export var start_color: Color = Color.BLACK
@export var end_color: Color = Color.RED
@export var ready_color: Color = Color.WHITE
#- pubvars
#- prvvars

var _time := 1.0
var _total_time := 60.0
#- onreadypubvars
#- onreadyprvvars
#- others


func is_it_a_demon(body: Node2D) -> void:
	if is_instance_of(body, EphEvilSprit):
		var spirit: EphEvilSprit = body
		spirit.ungrab_youngling()


func _process(delta: float) -> void:
	_time += delta
	var cur := 0.0
	if _time <= 0:
		cur = 1 + (_time / _total_time)
		bucket.modulate = self.start_color
		text.text = "Protect the younglings!"
	else:
		bucket.modulate = self.ready_color
		text.text = "Harvesting." + ".".repeat(int(_time * 3) % 3)
	timer.value = cur


func start_effect(total_time: float):
	assert(bucket)
	assert(timer)
	assert(text)
	self._time = -total_time
