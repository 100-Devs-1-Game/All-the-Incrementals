class_name JournalPageUI
extends Control


func open(data: JournalEntryData):
	%"TextureRect Page".texture = data.page
	%"Label Page".text = data.text
	show()


func _on_leave_pressed() -> void:
	hide()
	EventBus.stop_player_interaction.emit()
