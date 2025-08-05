extends Path2D

var move_speed := 0.5

@onready var inst = get_parent()

func _process(delta: float) -> void:
	if !inst.build_mode:
		if Input.is_action_pressed("left"):
			get_child(0).progress_ratio -= move_speed * delta
		if Input.is_action_pressed("right"):
			get_child(0).progress_ratio += move_speed * delta
	else:
		get_child(0).progress_ratio = 0.5
