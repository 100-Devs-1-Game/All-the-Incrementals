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
		if earth == n:
			return

		earth = n
		if Engine.is_editor_hint():
			_remove_and_add_essence(EARTH_ESSENCE, n)

		emit_changed()
	get():
		return get_essence(EARTH_ESSENCE)

@export var fire: int:
	set(n):
		if fire == n:
			return

		fire = n
		if Engine.is_editor_hint():
			_remove_and_add_essence(FIRE_ESSENCE, n)

		emit_changed()
	get():
		return get_essence(FIRE_ESSENCE)

@export var water: int:
	set(n):
		if water == n:
			return

		water = n
		if Engine.is_editor_hint():
			_remove_and_add_essence(WATER_ESSENCE, n)

		emit_changed()
	get():
		return get_essence(WATER_ESSENCE)

@export var wind: int:
	set(n):
		if wind == n:
			return

		wind = n
		if Engine.is_editor_hint():
			_remove_and_add_essence(WIND_ESSENCE, n)

		emit_changed()
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


# overwrites previous essence amount of a given type
func set_essence(essence: Essence, amount: int):
	for slot in slots:
		if slot.essence == essence:
			slot.amount = amount
			return
	add_stack(EssenceStack.new(essence, amount))


# completely deletes all essence, you never know :D
func clear_essence():
	slots.clear()


func get_essence(essence: Essence) -> int:
	for slot in slots:
		if slot.essence == essence:
			return slot.amount

	return 0


# checks if called inventory has any essence of that type
func has_essence(essence: Essence) -> bool:
	for slot in slots:
		if slot.essence == essence:
			return true
	return false


# merges stacks from other inventory into this one
func merge(other: EssenceInventory):
	for stack in other.slots:
		add_stack(stack)


# returns true if caller has more than the other
func has_stack(stack: EssenceStack) -> bool:
	return get_essence(stack.essence) >= stack.amount


# assuming we'll use this to check calling inv has enough for something
func has_inventory(other: EssenceInventory) -> bool:
	for stack in other.slots:
		if get_essence(stack.essence) < stack.amount:
			return false
	return true


func sub_stack(stack: EssenceStack):  # Removes x amount of essence from a given stack
	for slot in slots:
		if slot.essence == stack.essence:
			slot.amount -= stack.amount
			if slot.amount <= 0:
				slots.erase(slot)
			return


func sub_inventory(inventory: EssenceInventory):  # Removes all stack amounts from an inventory
	for stack in inventory.slots:
		sub_stack(stack)
