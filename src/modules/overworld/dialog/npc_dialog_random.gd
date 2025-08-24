class_name NPCDialogRandom
extends NPCDialogAlternative

@export var lines: Array[String]


func get_lines(dialog: NPCDialog) -> Array[String]:
	if dialog.state.current_index == 0:
		return [lines.pick_random()]
	return []


func advance(dialog: NPCDialog, _index: int):
	dialog.state.current_index += 1
