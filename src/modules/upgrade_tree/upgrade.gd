class_name MinigameUpgrade
extends Resource

@export var name: String
@export var description: String

@export var icon: Texture2D

# ------ cost and effects -------

# cost for each individual level
@export var cost_arr: Array[int]

# can be a multiplier, counter, etc for each level up
# for example, assuming an upgrade where the character moves 10% faster each level
# [ 0.1 , 0.2 , 0.3 , 0.4 , 0.5 ]
@export var effect_modifier_arr: Array[float]

# level required to unlock further upgrades
@export var unlock_level: int

# Upgrades that can get unlocked by this one
@export var unlocks: Array[MinigameUpgrade]

# Will serialize the current level too
@export_storage var current_level: int = 0
