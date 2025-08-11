class_name EarthTowerTumbleMinigame
extends BaseMinigame

signal game_started
signal life_lost
signal score_changed(value)
signal blocks_changed(value)

var lives: int = 3
var build_mode: bool = true

var score: int = 0:
	set(value):
		var _score = value
		score_changed.emit(_score)

var blocks_remaining: int = 18:
	set(value):
		var _blocks_remaining = value
		blocks_changed.emit(_blocks_remaining)


func _start():
	_begin()


func _begin():
	var n = 3
	for i in 3:
		$UI/TempUI/Display.text = str(n)
		await get_tree().create_timer(1.0).timeout
		n -= 1
	$UI/TempUI/Display.text = "Begin!"
	await get_tree().create_timer(1.0).timeout
	$UI/TempUI/Display.hide()
	game_started.emit()


func block_penalty():
	if lives >= 1:
		lives -= 1
		print(lives)
		life_lost.emit()
		if lives <= 0:
			game_over()


func force_update():
	score = score
	blocks_remaining = blocks_remaining
