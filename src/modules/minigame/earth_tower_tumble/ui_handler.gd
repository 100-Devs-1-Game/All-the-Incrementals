extends CanvasLayer

# handles all ui changes (temporary)

var state

@onready var life_container = $LifeContainer
@onready var score_label = $Score
@onready var block_label = $Blocks

const HEARTS_EMPTY = preload("res://assets/minigames/earth_tower_tumble/hearts_empty.png")
const HEARTS_FULL = preload("res://assets/minigames/earth_tower_tumble/hearts_full.png")

@onready var minigame = get_tree().current_scene

func _ready() -> void:
	minigame.score_changed.connect(_on_score_changed)
	minigame.blocks_changed.connect(_on_blocks_changed)
	minigame.life_lost.connect(_on_lives_changed)
	minigame.force_update()
	setup()

func _on_score_changed(value):
	score_label.text = "Score: " + str(value)

func _on_lives_changed():
	for i in range(life_container.get_child_count() - 1, -1, -1):
		var cont = life_container.get_child(i)
		if cont is TextureRect:
			if cont.texture == HEARTS_FULL:
				cont.set_texture(HEARTS_EMPTY)
				return

func _on_blocks_changed(value):
	block_label.text = "Blocks Remaining: " + str(value)


func setup():
	for i in minigame.lives:
		var life = TextureRect.new()
		life.set_texture(HEARTS_FULL)
		$LifeContainer.add_child(life)
		
