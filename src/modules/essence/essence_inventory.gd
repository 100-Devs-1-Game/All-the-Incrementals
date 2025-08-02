@tool
class_name EssenceInventory
extends Resource

#
# Introduce hard-coding of essences so this Resource is easier
# to use in the Inspector, without having to edit nested Resources

const EARTH_ESSENCE = preload("res://modules/essence/resources/earth.tres")
const FIRE_ESSENCE = preload("res://modules/essence/resources/fire.tres")
const WATER_ESSENCE = preload("res://modules/essence/resources/water.tres")
const WIND_ESSENCE = preload("res://modules/essence/resources/wind.tres")

@export var earth: int:
	set(n):
		earth = n
		if Engine.is_editor_hint():
			_remove_and_add_essence(EARTH_ESSENCE, n)

@export var fire: int:
	set(n):
		fire = n
		if Engine.is_editor_hint():
			_remove_and_add_essence(FIRE_ESSENCE, n)

@export var water: int:
	set(n):
		water = n
		if Engine.is_editor_hint():
			_remove_and_add_essence(WATER_ESSENCE, n)

@export var wind: int:
	set(n):
		wind = n
		if Engine.is_editor_hint():
			_remove_and_add_essence(WIND_ESSENCE, n)

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

# TODO sub_stack, has_essence, has_stack, merge, ...
