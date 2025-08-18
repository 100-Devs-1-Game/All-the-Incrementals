extends EPHRandomPositionSpawner

const BASE_SPAWN_COOLDOWN = 2.5
@export var _potato_swawn_zone: Node2D
#@export var _player: TopDown2DCharacterController
@export var _overshoot_potato: float = 1000

var _minigame: EarthPotatoHerdingMinigame
var _player_instantly_kills


func _ready() -> void:
	_player_instantly_kills = false
	_minigame = get_tree().get_first_node_in_group("earth_potato_herding")
	_minigame.destroy_dashing_spirits.connect(_on_destroy_spirits)
	_minigame.less_dashing_spirits.connect(_on_less_dashing_spirits)
	super()


func _on_destroy_spirits(unlocked: bool) -> void:
	_player_instantly_kills = unlocked


func _on_less_dashing_spirits(modifier: float) -> void:
	_spawn_cooldown = BASE_SPAWN_COOLDOWN * (1 + modifier)


func get_generic_spawnable_node() -> Node:
	print("Spawning dasher")
	var node = _spawnable_node_scene.instantiate() as EphEvilDashingSprit
	node._player_instantly_kills = _player_instantly_kills

	node.add_state_move_direction_strategy(
		"go_to_nearest_youngling",
		TD2DCMDSGoToPoint.new().set_point_generator(
			GoThroughNearestNode2dChildPositionGenerator.new(
				node, _potato_swawn_zone, _overshoot_potato
			)
		)
	)

	return node
