class_name MinigameData
extends Resource

# Minigame name in-game
@export var display_name: String

# the game scene of this Minigame
@export var minigame_scene: PackedScene

# the root nodes ( entry points ) of the Minigames Upgrade Tree
@export var upgrade_tree_root_nodes: Array[MinigameUpgrade]

# Essence player gains from playing this
@export var output_essence: Essence
# turns score into Essence
@export var currency_conversion_factor: float

# stores the top n highscores
@export_storage var high_scores: Array[int]
