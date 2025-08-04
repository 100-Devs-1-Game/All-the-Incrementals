extends BaseMinigame

@onready var block_handler = $BlockSpawner

func _start():
	block_handler.start()
