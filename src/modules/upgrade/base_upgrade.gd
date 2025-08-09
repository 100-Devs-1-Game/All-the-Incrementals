@tool
class_name BaseUpgrade
extends Resource

enum ModifierFormat { PERCENTAGE, ADDITIVE, MULTIPLIER }

const NO_LEVEL = -1

## how this Upgrade is called in-game
@export var name: String

## static flavor text
@export var flavor: String

@export var icon: Texture2D
@export var position: Vector2

# ------ cost and effects -------

## cost for each individual level
@export var cost_arr: Array[EssenceInventory]

## can be a multiplier, additive, percentage, etc for each level up
@export var effect_modifier_arr: Array[float]

@export_category("Algorithmic")

## optional: _setting cost and effect algorithmically ( arrays will be updated in the _setter )
@export var max_level: int:
	set = _set_max_level

## cost for level 1
@export var base_cost: EssenceInventory:
	set = _set_base_cost
## cost multiplier per level[br]
## base cost + (base cost modifier * level)
@export var base_cost_multiplier: float:
	set = _set_base_cost_multiplier

## make costs scale exponentially
@export var exponential_cost: bool = true:
	set = _set_exponential_cost

## only affects exponential costs[br]
## less smoothness => more precise, more smoothness => more rounding
@export var round_smoothness: float = 1.0:
	set = _set_round_smoothness

## effect modifier for level 1
@export var base_effect_modifier: float:
	set = _set_base_effect_modifier
## modifer multiplier per level[br]
## base modifier + (modifier multiplier * level)
@export var effect_modifier_multiplier: float:
	set = _set_effect_modifier_multiplier

## optional: _setting cost via curve ( arrays will be updated in the _setter  )
@export var cost_curve: Curve:
	set = _set_cost_curve

@export_category("Unlocking")

## has it been unlocked by a previous upgrade
@export_storage var unlocked: bool = false

## level required to unlock all further upgrades of this branch
@export var unlock_level: int

## Upgrades that can get unlocked by this one
@export var unlocks: Array[Resource]

@export_category("Description")

## dynamic description for get_description()
## format: prefix + " " + formatted modifier + " " + suffix
@export var description_prefix: String
@export var description_suffix: String

## PERCENTAGE: "[N*100]%" or "-[N*100]%"
## ADDITIVE:   "+N" or "-N"
## MULTIPLIER  "xN" or "/N" (?)
@export var description_modifier_format: ModifierFormat


func _construct_cost_and_modifier_arrays():
	if not Engine.is_editor_hint():
		return

	if max_level <= 0:
		push_error("failed to calculate costs/effect - max level is not _set")
		return

	if base_cost && base_cost.slots && base_cost_multiplier > 0:
		cost_arr = []
		for i in range(max_level):
			var new_cost: EssenceInventory = EssenceInventory.new()
			for stack: EssenceStack in base_cost.slots:
				var cost_calc: int
				if exponential_cost:
					cost_calc = round_nice(
						stack.amount * pow(base_cost_multiplier, i), round_smoothness
					)
				else:
					cost_calc = stack.amount + int(base_cost_multiplier * i)
				new_cost.add_stack(EssenceStack.new(stack.essence, cost_calc))
			cost_arr.append(new_cost)

	if base_effect_modifier > 0 && effect_modifier_multiplier > 0:
		effect_modifier_arr = []
		for i in range(max_level):
			effect_modifier_arr.append(base_effect_modifier + (effect_modifier_multiplier * i))


func get_uid() -> int:
	return ResourceLoader.get_resource_uid(resource_path)


func level_up() -> void:
	var current_level = get_level()
	if is_maxed_out():
		push_error("Tried to level up past max level")
		return
	SaveGameManager.world_state.minigame_unlock_levels[get_uid()] = (current_level + 1)
	SaveGameManager.save()


func level_down() -> void:
	var current_level = get_level()
	#TODO: this shouldn't need a +1, but it causes an assert elsewhere
	if current_level <= NO_LEVEL + 1:
		push_error("Tried to level down past min level")
		return
	SaveGameManager.world_state.minigame_unlock_levels[get_uid()] = (current_level - 1)
	SaveGameManager.save()


# 0 = level 1, ...
func get_level() -> int:
	return SaveGameManager.world_state.minigame_unlock_levels.get(get_uid(), NO_LEVEL)


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
	# _setting the effect for level -1 for max effect is likely not intended.
	assert(level > NO_LEVEL)
	return effect_modifier_arr[level]


func get_current_effect_modifier() -> float:
	return get_effect_modifier(get_level())


func is_unlocked() -> bool:
	return unlocked


func is_maxed_out() -> bool:
	return get_level() == get_max_level()


func get_next_level_cost() -> EssenceInventory:
	if is_maxed_out():
		return null
	return cost_arr[get_level() + 1]


func can_afford_next_level() -> bool:
	if is_maxed_out():
		return false
	return Player.can_afford(get_next_level_cost())


func _set_max_level(level: int):
	max_level = level
	if max_level:
		_construct_cost_and_modifier_arrays()


func _set_base_cost(cost: EssenceInventory):
	base_cost = cost
	if base_cost:
		_construct_cost_and_modifier_arrays()


func _set_base_cost_multiplier(multiplier: float):
	base_cost_multiplier = multiplier
	if base_cost_multiplier:
		_construct_cost_and_modifier_arrays()


func _set_exponential_cost(b: bool):
	exponential_cost = b
	_construct_cost_and_modifier_arrays()


func _set_round_smoothness(factor: float):
	round_smoothness = factor
	_construct_cost_and_modifier_arrays()


func _set_base_effect_modifier(modifier: float):
	base_effect_modifier = modifier
	if base_effect_modifier:
		_construct_cost_and_modifier_arrays()


func _set_effect_modifier_multiplier(multiplier: float):
	effect_modifier_multiplier = multiplier
	if effect_modifier_multiplier:
		_construct_cost_and_modifier_arrays()


func _set_cost_curve(curve: Curve):
	cost_curve = curve
	if cost_curve:
		pass


# rounds to nearest 1, 5, 10.. depending on how large x is & the smoothness
static func round_nice(x, smoothness: float) -> int:
	var base: float = x * smoothness * 0.1

	var steps := [1, 5, 10, 50, 100, 500, 1000]
	var nice: int = 1

	for i in steps:
		nice = i
		if base <= i:
			break

	return floor(x / float(nice)) * nice
