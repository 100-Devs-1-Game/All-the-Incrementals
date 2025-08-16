extends EPHRandomPositionSpawner

const BASE_SPAWN_COOLDOWN = 2.5

@export var _potato_swawn_zone: Node2D
@export var _player: TopDown2DCharacterController

var _minigame: EarthPotatoHerdingMinigame
var _player_instantly_kills


func _ready() -> void:
	_player_instantly_kills = false
	_minigame = get_tree().get_first_node_in_group("earth_potato_herding")
	_minigame.destroy_evil_spirits.connect(_on_destroy_spirits)
	_minigame.less_evil_spirits.connect(_on_less_evil_spirits)
	super()


func _on_destroy_spirits(unlocked: bool) -> void:
	_player_instantly_kills = unlocked


func _on_less_evil_spirits(modifier: float) -> void:
	_spawn_cooldown = BASE_SPAWN_COOLDOWN * (1 + modifier)


func get_generic_spawnable_node() -> Node:
	print("Spawning evil")
	var node = _spawnable_node_scene.instantiate() as EphEvilSprit
	node._player_instantly_kills = _player_instantly_kills

	node.add_state_move_direction_strategy(
		"go_to_nearest_youngling",
		(
			TD2DCMDSGoToPoint
			. new()
			. set_point_generator(
				GoToNearestNode2dChildPositionGenerator.new(node, _potato_swawn_zone)
			)
			. update_point_on_every_call()
		)
	)

	node.add_state_move_direction_strategy(
		"go_away_from_player",
		(
			TD2DCMDSGoToPoint
			. new()
			. set_point_generator(GoAwayFromNode2D.new(node, _player))
			. update_point_on_every_call()
		)
	)
	return node
