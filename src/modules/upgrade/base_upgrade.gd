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
@export var cost_arr: Array[EssenceInventory]

# can be a multiplier, additive, percentage, etc for each level up
@export var effect_modifier_arr: Array[float]

# optional: setting cost and effect algorithmically ( arrays will be updated in the setter )
@export var max_level: int:
	set = set_max_level

# cost for level 1
@export var base_cost: EssenceInventory:
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

# has it been unlocked by a previous upgrade
@export_storage var unlocked: bool = false

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


func _construct_cost_and_modifier_arrays():
	if (
		not max_level
		or not base_cost
		or not base_cost.slots
		or not base_cost_multiplier
		or not base_effect_modifier
		or not effect_modifier_multiplier
	):
		print("Some algorithmic upgrade settings have been set in %s but not all" % name)
		return
	cost_arr = []
	effect_modifier_arr = []
	for i in range(max_level):
		var new_cost: EssenceInventory = EssenceInventory.new()
		for stack: EssenceStack in base_cost.slots:
			var new_stack = EssenceStack.new()
			new_stack.essence = stack.essence
			new_stack.amount = stack.amount * base_cost_multiplier * (i + 1)
			new_cost.slots.append(new_stack)
		cost_arr.append(new_cost)
		effect_modifier_arr.append(base_effect_modifier * effect_modifier_multiplier * (i + 1))


func level_up() -> void:
	assert(current_level < get_max_level())
	current_level += 1


# 0 = level 1, ...
func get_level() -> int:
	return current_level


# 0 = level 1, ...
func get_max_level() -> int:
	return cost_arr.size() - 1


func get_description() -> String:
	# TODO
	return ""


# 0 = level 1, ...
func get_cost(level: int) -> EssenceInventory:
	assert(cost_arr.size() > level)
	return cost_arr[level]


# 0 = level 1, ...
func get_effect_modifier(level: int) -> float:
	assert(effect_modifier_arr.size() > level)
	return effect_modifier_arr[level]


func get_current_effect_modifier() -> float:
	return get_effect_modifier(current_level)


func is_unlocked() -> bool:
	return unlocked


func is_maxed_out() -> bool:
	return current_level == get_max_level()


func get_next_level_cost() -> EssenceInventory:
	if is_maxed_out():
		return null
	return cost_arr[current_level + 1]


func can_afford_next_level() -> bool:
	if is_maxed_out():
		return false
	return Player.can_afford(get_next_level_cost())


func set_max_level(level: int):
	max_level = level
	if max_level:
		_construct_cost_and_modifier_arrays()


func set_base_cost(cost: EssenceInventory):
	base_cost = cost
	if base_cost:
		_construct_cost_and_modifier_arrays()


func set_base_cost_multiplier(multiplier: float):
	base_cost_multiplier = multiplier
	if base_cost_multiplier:
		_construct_cost_and_modifier_arrays()


func set_base_effect_modifier(modifier: float):
	base_effect_modifier = modifier
	if base_effect_modifier:
		_construct_cost_and_modifier_arrays()


func set_effect_modifier_multiplier(multiplier: float):
	effect_modifier_multiplier = multiplier
	if effect_modifier_multiplier:
		_construct_cost_and_modifier_arrays()


func set_cost_curve(curve: Curve):
	cost_curve = curve
	if cost_curve:
		pass
