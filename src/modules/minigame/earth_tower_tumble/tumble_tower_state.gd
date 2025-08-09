class_name TowerTumbleState

var build_mode: bool = true

signal lives_changed()
signal score_changed(value)
signal blocks_changed(value)

var lives: int = 3:
	set(value):
		lives = value
		lives_changed.emit(value)

var score: int = 0:
	set(value):
		score = value
		score_changed.emit(value)

var blocks_remaining: int = 18:
	set(value):
		blocks_remaining = value
		blocks_changed.emit(value)
		print("value changes")

func force_update():
	lives_changed.emit()
	score_changed.emit(score)
	blocks_changed.emit(blocks_remaining)
	print(blocks_remaining)

func reset():
	lives = 0
	score = 0
	blocks_remaining = 18
	build_mode = true
