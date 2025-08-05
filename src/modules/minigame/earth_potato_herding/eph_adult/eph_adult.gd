class_name EphAdult
extends TopDown2DCharacterController

@export var _close_to_bucket_margin: float = 10

#region ------------------------ PUBLIC VARS -----------------------------------

var bucket_node: Node2D
var mini_game: EarthPotatoHerdingMinigame
var score: int

#endregion

#region ======================== PUBLIC METHODS ================================


func _ready() -> void:
	mini_game = get_tree().root.get_node("EarthPotatoHerding")
	score = mini_game.get_potato_score(self)


func is_close_to_bucket() -> bool:
	return (
		global_position.distance_squared_to(bucket_node.global_position)
		< _close_to_bucket_margin ** 2
	)


func add_self_to_bucket() -> void:
	mini_game.add_score(score)
	TextFloatSystem.floating_text(global_position, "+%d" % score, mini_game)
	if get_tree().get_nodes_in_group("potatoes").size() == 1:
		# Last potato standing, it's game over
		mini_game.game_over()
	queue_free()


#endregion

#region ======================== PRIVATE METHODS ================================


func _on_nutritious_potato_changed(modifier: float) -> void:
	print("Nutrition!")
	score = int(1 + modifier)


func _on_adult_saw_spirit_body_entered(body: Node2D) -> void:
	if get_tree().get_nodes_in_group("potatoes").size() == 1:
		# Last potato standing, it's game over
		mini_game.game_over()
	body.queue_free()
	self.queue_free()

#endregion
