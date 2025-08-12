extends CanvasLayer

# Handles all UI changes (temporary)

const HEARTS_EMPTY := preload("res://assets/minigames/earth_tower_tumble/hearts_empty.png")
const HEARTS_FULL  := preload("res://assets/minigames/earth_tower_tumble/hearts_full.png")

@onready var life_container = $LifeContainer
@onready var score_label    = $Score
@onready var block_label    = $Blocks
@onready var minigame: EarthTowerTumbleMinigame = get_tree().current_scene

func _ready() -> void:
	minigame.score_changed.connect(_on_score_changed)
	minigame.blocks_changed.connect(_on_blocks_changed)
	minigame.life_lost.connect(_on_lives_changed)
	setup()
	minigame.force_update()

func _on_score_changed(value):
	score_label.text = "Score: %s" % value

func _on_blocks_changed(value):
	block_label.text = "Blocks Remaining: %s" % value

func _on_lives_changed():
	for i in range(life_container.get_child_count() - 1, -1, -1):
		var node := life_container.get_child(i)
		if node is TextureRect and node.texture == HEARTS_FULL:
			node.texture = HEARTS_EMPTY
			return

func setup():
	for c in life_container.get_children():
		c.queue_free()

	for _i in range(minigame.lives):
		var heart := TextureRect.new()
		heart.texture = HEARTS_FULL
		life_container.add_child(heart)
