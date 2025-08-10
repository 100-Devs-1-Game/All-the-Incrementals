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
@export var start_color: Color = Color.WHITE
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
	if _time >= 0:
		bucket.modulate = self.ready_color
	else:
		var cur := -(_time / _total_time)
		var diff := sin(_time)
		if diff > 0:
			cur += (1 - cur) * diff
		else:
			cur += cur * diff
		bucket.modulate = self.end_color.lerp(self.start_color, cur)
		print([-_time / _total_time, cur, bucket.modulate])


func start_effect(total_time: float):
	assert(bucket)
	self._time = -total_time
