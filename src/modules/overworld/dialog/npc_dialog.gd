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
		else:
			var prefix: String
			if state.current_index % 2 == 0:
				prefix = npc_name + ": "
			return [prefix + lines[state.current_index]]

	return alternative_dialog.get_lines(self)


func advance():
	state.current_index += 1
