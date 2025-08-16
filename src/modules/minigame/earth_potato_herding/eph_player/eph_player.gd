extends TopDown2DCharacterController

const BASE_PLAYER_SPEED = Vector2(300.0, 300.0)
const SHADER_CIRCLE_DEFAULT_RADIUS = 20.5


func _ready() -> void:
	var mini_game = get_tree().get_first_node_in_group("earth_potato_herding")
	mini_game.spirit_keeper_speed.connect(_on_player_speed_changed)
	mini_game.spirit_keeper_brightness.connect(_on_player_brightness_changed)
	$Sprite.play("down_idle")


func _exit_tree() -> void:
	var mini_game = get_tree().get_first_node_in_group("earth_potato_herding")
	mini_game.spirit_keeper_speed.disconnect(_on_player_speed_changed)
	mini_game.spirit_keeper_brightness.disconnect(_on_player_brightness_changed)


func _on_evil_spirit_repel_area_body_entered(body: Node2D) -> void:
	body.start_repel_from_player()


func _on_evil_spirit_repel_area_body_exited(body: Node2D) -> void:
	body.stop_repel_from_player()


func _on_youngling_herd_area_body_entered(body: Node2D) -> void:
	body.start_herd_by_player()


func _on_youngling_herd_area_body_exited(body: Node2D) -> void:
	body.stop_herd_by_player()


func _on_player_speed_changed(modifier: float) -> void:
	print("Player speed changed %s" % modifier)
	var perc_scale = 1 + modifier / 100
	_base_speed.x = BASE_PLAYER_SPEED.x * perc_scale
	_base_speed.y = BASE_PLAYER_SPEED.y * perc_scale


func _on_player_brightness_changed(modifier: float) -> void:
	print("Player brightness changed %s" % modifier)
	var perc_scale = 1 + modifier / 100
	$EvilSpiritRepelArea/CollisionShape2D.scale = Vector2(perc_scale, perc_scale)
	$YounglingHerdArea/CollisionShape2D.scale = Vector2(perc_scale, perc_scale)
	$HerdCircle.material.set_shader_parameter(
		"min_radius", SHADER_CIRCLE_DEFAULT_RADIUS * perc_scale
	)
