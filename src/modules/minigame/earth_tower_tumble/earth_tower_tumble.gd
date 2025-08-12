class_name EarthTowerTumbleMinigame
extends BaseMinigame

signal game_started
signal life_lost
signal score_changed(value)
signal blocks_changed(value)

var lives := 3
var build_mode := true

var score := 0:
	set(value):
		score = value
		score_changed.emit(value)

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
	score += amount


func block_penalty():
	if lives > 0:
		lives -= 1
		print(lives)
		life_lost.emit()
		if lives <= 0:
			game_over()


func force_update():
	score_changed.emit(score)
	blocks_changed.emit(blocks_remaining)
