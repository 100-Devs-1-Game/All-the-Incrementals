class_name EssenceStack
extends Resource

@export var essence: Essence
@export var amount: int


func merge(stack: EssenceStack):
	assert(essence == stack.essence)
	amount += stack.amount
