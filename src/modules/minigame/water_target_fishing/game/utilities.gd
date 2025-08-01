class_name WTFUtilities
extends Node

# eh, a little bit useful. I need templates :(


static func enum_to_string(dictionary: Dictionary, value: Variant) -> StringName:
	return dictionary.keys()[dictionary.values().find(value)]


static func random_enum(dictionary: Dictionary) -> Variant:
	var values := dictionary.values()
	return values[randi() % values.size()]
