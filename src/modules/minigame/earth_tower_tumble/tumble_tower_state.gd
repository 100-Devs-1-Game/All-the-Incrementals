class_name TowerTumbleState

var build_mode: bool = true
var total_lives: int = 3

signal lives_changed()
signal score_changed(value)
signal blocks_changed(value)

var lives: int = 3:
	set(value):
		var _lives = value
		lives_changed.emit(value)

var score: int = 0:
	set(value):
		var _score = value
		score_changed.emit(_score)

var blocks_remaining: int = 18:
	set(value):
		var _blocks_remaining = value
		blocks_changed.emit(_blocks_remaining)

func force_update():
	lives_changed.emit()
	score_changed.emit(score)
	blocks_changed.emit(blocks_remaining)

func reset():
	lives = 0
	score = 0
	blocks_remaining = 18
	build_mode = true
