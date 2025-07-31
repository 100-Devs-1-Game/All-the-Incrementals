class_name EssenceInventory
extends Resource

@export var slots: Array[EssenceStack]


func add_stack(stack: EssenceStack):
	for slot in slots:
		if slot.essence == stack.essence:
			slot.merge(stack)
			return

# TODO sub_stack, has_essence, has_stack, merge, ...
