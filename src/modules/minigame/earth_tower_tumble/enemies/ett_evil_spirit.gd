extends RigidBody2D

enum behaviours {
	PUSH,
	DAMAGE
}

var damage_amount: = 5
var float_speed: = 80.50
var behaviour: behaviours
var grabbing: bool = false
var target

func _ready() -> void:
	behaviour = behaviours.values().pick_random()
	if behaviour == behaviours.PUSH:
		$collider.disabled = false
		$Polygon2D.color = Color.PURPLE
	$Area2D.area_entered.connect(touched)
	$Area2D.body_entered.connect(touched)


func _process(delta: float) -> void:
	if !grabbing:
		if target:
			move_to_location(delta)
		else:
			print("Getting a target")
			pick_target()


func pick_target():
	var options = get_tree().get_nodes_in_group("block")
	if !options.is_empty():
		target = options.pick_random()
	else:
		queue_free()


func move_to_location(delta):
	var direction = target.global_position - global_position
	direction = direction.normalized()
	global_position += direction * float_speed * delta


func touched(other):
	if other.is_in_group("potato"):
		print("Spirit hit")
		queue_free()
	elif other.is_in_group("block"):
		match behaviour:
			behaviours.DAMAGE:
				other.damage(damage_amount)
