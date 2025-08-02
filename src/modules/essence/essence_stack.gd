class_name EssenceStack
extends Resource

@export var essence: Essence
@export var amount: int


func _init(p_essence: Essence = null, p_amount: int = 0):
	essence = p_essence
	amount = p_amount


func merge(stack: EssenceStack):
	assert(essence == stack.essence)
	amount += stack.amount
