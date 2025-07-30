class_name BaseUpgrade
extends Resource

enum ModifierFormat { PERCENTAGE, ADDITIVE, MULTIPLIER }

# how this Upgrade is called in-game
@export var name: String

# static flavor text
@export var flavor: String

@export var icon: Texture2D
@export var position: Vector2

# ------ cost and effects -------

# cost for each individual level
@export var cost_arr: Array[EssenceStack]

# can be a multiplier, additive, percentage, etc for each level up
@export var effect_modifier_arr: Array[float]

# optional: setting cost and effect algorithmically ( arrays will be updated in the setter )
@export var max_level: int:
	set = set_max_level

# cost for level 1
@export var base_cost: int:
	set = set_base_cost
# cost multiplier per level
@export var base_cost_multiplier: float:
	set = set_base_cost_multiplier

# effect modifier for level 1
@export var base_effect_modifier: float:
	set = set_base_effect_modifier
# modifer multiplier per level
@export var effect_modifier_multiplier: float:
	set = set_effect_modifier_multiplier

# optional: setting cost via curve ( arrays will be updated in the setter  )
@export var cost_curve: Curve:
	set = set_cost_curve

# ------

# level required to unlock all further upgrades of this branch
@export var unlock_level: int

# Upgrades that can get unlocked by this one
@export var unlocks: Array[BaseUpgrade]

# dynamic description for get_description()
# format: prefix + " " + formatted modifier + " " + suffix
@export var description_prefix: String
@export var description_suffix: String

# PERCENTAGE: "[N*100]%" or "-[N*100]%"
# ADDITIVE:   "+N" or "-N"
# MULTIPLIER  "xN" or "/N" (?)
@export var description_modifier_format: ModifierFormat

# TODO decimals

# Will serialize the current level too.
# -1 = not bought yet
# 0 = level 1, ...
@export_storage var current_level: int = -1


func level_up() -> void:
	current_level += 1


func get_max_level() -> int:
	return cost_arr.size() + 1


func get_description() -> String:
	# TODO
	return ""


func set_max_level(level: int):
	max_level = level
	# TODO


func set_base_cost(cost: int):
	base_cost = cost
	# TODO


func set_base_cost_multiplier(multiplier: float):
	base_cost_multiplier = multiplier
	# TODO


func set_base_effect_modifier(modifier: float):
	base_effect_modifier = modifier
	# TODO


func set_effect_modifier_multiplier(multiplier: float):
	effect_modifier_multiplier = multiplier
	# TODO


func set_cost_curve(curve: Curve):
	cost_curve = curve
	# TODO
