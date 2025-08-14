class_name EarthTowerTumbleMinigame
extends BaseMinigame

signal game_started
signal life_lost
signal score_changed(value)
signal blocks_changed(value)

@export var player: Node2D
@export var base: Node2D
@export var enemy_spawner: Node2D
@export var block_spawner: Node2D
@export var game_ui: CanvasLayer

var lives := 3
var build_mode := true

var blocks_remaining := 18:
	set(value):
		blocks_remaining = value
		blocks_changed.emit(value)


func _start():
	_begin()
	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node: Node):
	await node.ready
	if node.is_in_group("block"):
		node.placed.connect(_on_block_placed)


func _begin():
	for n in range(3, 0, -1):
		$UI/TempUI/Display.text = str(n)
		await get_tree().create_timer(1.0).timeout
	$UI/TempUI/Display.text = "Begin!"
	await get_tree().create_timer(1.0).timeout
	$UI/TempUI/Display.hide()
	game_started.emit()


func _on_block_placed(amount: int):
	add_score(amount)
	$UI/TempUI/Score.text = "Score: " + str(get_score())


func block_penalty():
	if lives > 0:
		lives -= 1
		print(lives)
		life_lost.emit()
		if lives <= 0:
			game_over()


func player_speed_modifier(modifier):
	player.direction_speed = player.direction_speed * modifier
	print("SPEED CHANGED TO: ", player.direction_speed)


func player_conjure_modifier(modifier):
	player.shoot_delay = player.shoot_delay - modifier


func force_update():
	blocks_changed.emit(blocks_remaining)
