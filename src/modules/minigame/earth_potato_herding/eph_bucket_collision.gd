extends Area2D


func is_it_a_demon(body: Node2D) -> void:
	if is_instance_of(body, EphEvilSprit):
		var spirit: EphEvilSprit = body
		spirit.ungrab_youngling()
