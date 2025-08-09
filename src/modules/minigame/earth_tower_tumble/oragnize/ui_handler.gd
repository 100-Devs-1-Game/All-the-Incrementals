extends CanvasLayer

# handles all ui changes (temporary)

var state: TowerTumbleState

@onready var life_container = $LifeContainer
@onready var score_label = $Score
@onready var block_label = $Blocks

const HEARTS_EMPTY = preload("res://assets/minigames/earth_tower_tumble/hearts_empty.png")
const HEARTS_FULL = preload("res://assets/minigames/earth_tower_tumble/hearts_full.png")

func set_state(new_state: TowerTumbleState):
	state = new_state
	state.score_changed.connect(_on_score_changed)
	await get_tree().create_timer(1.0).timeout
	state.force_update()

func _on_score_changed(value):
	score_label.text = "Score: " + str(value)

func _on_lives_changed():
	for i in range(life_container.get_child_count() - 1, -1, -1):
		var cont = life_container.get_child(i)
		if cont.texture == HEARTS_FULL:
			cont.set_texture(HEARTS_EMPTY)
			return

func _on_blocks_changed(value):
	block_label.text = "Blocks Remaining: " + str(value)
