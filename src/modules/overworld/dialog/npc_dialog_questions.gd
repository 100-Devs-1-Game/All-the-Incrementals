class_name NPCDialogQuestions
extends NPCDialogAlternative

@export var questions: Array[String]
@export var answers: Array[String]


func get_lines(dialog: NPCDialog) -> Array[String]:
	if dialog.state.current_index == 0:
		return questions

	return [answers[dialog.state.current_index - 1]]


func advance(dialog: NPCDialog, index: int):
	if dialog.state.current_index > 0:
		dialog.state.current_index = 0
	elif index > -1:
		dialog.state.current_index = index + 1
