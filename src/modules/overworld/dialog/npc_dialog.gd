class_name NPCDialog
extends Resource

@export var npc_name: String

# each line different character, alternating NPC, Player, Npc..
@export_multiline var initial_dialog: String

# happens after the initial dialog, or immediately when initial dialog
# is already known
@export var alternative_dialog: NPCDialogAlternative

var state: NPCDialogState


func get_next_lines() -> Array[String]:
	if state.show_initial:
		var lines := initial_dialog.split("\n", false)
		if state.current_index >= lines.size():
			state.show_initial = false
			state.current_index = 0
			if alternative_dialog and alternative_dialog is NPCDialogRandom:
				return []
		else:
			var prefix: String
			if state.current_index % 2 == 0:
				prefix = npc_name + ": "
			return [prefix + lines[state.current_index]]

	if alternative_dialog:
		return alternative_dialog.get_lines(self)

	return []


func advance(index: int = -1):
	if state.show_initial:
		state.current_index += 1
	else:
		assert(alternative_dialog)
		alternative_dialog.advance(self, index)
