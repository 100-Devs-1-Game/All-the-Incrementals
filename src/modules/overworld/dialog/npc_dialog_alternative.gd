class_name NPCDialogAlternative
extends Resource


func get_lines(_dialog: NPCDialog) -> Array[String]:
	assert(false, "abstract function")
	return []


func advance(_dialog: NPCDialog, _index: int):
	assert(false, "abstract function")
	return
