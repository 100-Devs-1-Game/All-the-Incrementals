@tool
class_name EssenceInventory
extends Resource

#
# Introduce hard-coding of essences so this Resource is easier
# to use in the Inspector, without having to edit nested Resources

const EARTH_ESSENCE = preload("uid://j13h5v6bwmxe")
const FIRE_ESSENCE = preload("uid://kwd3sg27pka7")
const WATER_ESSENCE = preload("uid://td664oe8wk42")
const WIND_ESSENCE = preload("uid://df7knsfckprdd")

@export var earth: int:
	set(n):
		earth = n
		if Engine.is_editor_hint():
			_remove_and_add_essence(EARTH_ESSENCE, n)
	get():
		return get_essence(EARTH_ESSENCE)

@export var fire: int:
	set(n):
		fire = n
		if Engine.is_editor_hint():
			_remove_and_add_essence(FIRE_ESSENCE, n)
	get():
		return get_essence(FIRE_ESSENCE)

@export var water: int:
	set(n):
		water = n
		if Engine.is_editor_hint():
			_remove_and_add_essence(WATER_ESSENCE, n)
	get():
		return get_essence(WATER_ESSENCE)

@export var wind: int:
	set(n):
		wind = n
		if Engine.is_editor_hint():
			_remove_and_add_essence(WIND_ESSENCE, n)
	get():
		return get_essence(WIND_ESSENCE)

@export var slots: Array[EssenceStack]


func _remove_and_add_essence(essence: Essence, n: int):
	# so changes don't get added
	remove_essence(essence)
	add_essence(essence, n)


func add_stack(stack: EssenceStack):
	for slot in slots:
		if slot.essence == stack.essence:
			slot.merge(stack)
			return
	slots.append(stack)


# convenience function
func add_essence(essence: Essence, amount: int):
	if amount < 1:
		return
	add_stack(EssenceStack.new(essence, amount))


func remove_essence(essence: Essence):
	for slot in slots:
		if slot.essence == essence:
			slots.erase(slot)
			return


func get_essence(essence: Essence) -> int:
	for slot in slots:
		if slot.essence == essence:
			return slot.amount

	return 0

# TODO sub_stack, has_essence, has_stack, merge, ...
