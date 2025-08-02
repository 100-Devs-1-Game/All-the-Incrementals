extends TopDown2DCharacterController

const BASE_PLAYER_SPEED = Vector2(300.0, 300.0)


func _ready() -> void:
	var mini_game = get_tree().root.get_node("EarthPotatoHerding")
	mini_game.connect("spirit_keeper_speed", _on_player_speed_changed)
	mini_game.connect("spirit_keeper_brightness", _on_player_brightness_changed)


func _on_evil_spirit_repel_area_body_entered(body: Node2D) -> void:
	body.queue_free()


func _on_player_speed_changed(modifier: float) -> void:
	print("Player speed changed %s" % modifier)
	_base_speed.x = BASE_PLAYER_SPEED.x * modifier
	_base_speed.y = BASE_PLAYER_SPEED.y * modifier


func _on_player_brightness_changed(modifier: float) -> void:
	print("Player brightness changed %s" % modifier)
	$EvilSpiritRepelArea/CollisionShape2D.scale = Vector2(modifier, modifier)
