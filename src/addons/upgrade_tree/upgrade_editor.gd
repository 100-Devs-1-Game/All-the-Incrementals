@tool
extends GraphNode
class_name UpgradeEditor

@export var upgrade: MinigameUpgrade

# Called when the node enters the scene tree for the first time.


func _ready() -> void:
	$TableContainer.hide()
	$TableContainer/Name/LineEdit.text_changed.connect(_on_name_edited)
	$TableContainer/Description/LineEdit.text_changed.connect(_on_description_edited)

	var icon_picker = EditorResourcePicker.new()
	icon_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	icon_picker.set_base_type("Texture2D")
	icon_picker.resource_changed.connect(_on_icon_changed)
	$TableContainer/Icon.add_child(icon_picker)

	var upgrade_logic_picker = EditorResourcePicker.new()
	upgrade_logic_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	upgrade_logic_picker.set_base_type("Script")
	upgrade_logic_picker.resource_changed.connect(_on_upgrade_logic_changed)
	$TableContainer/UpgradeLogic.add_child(upgrade_logic_picker)


func _on_name_edited(name: String) -> void:
	title = name
	upgrade.name = name


func _on_description_edited(name: String) -> void:
	title = name
	upgrade.description = name


func _on_icon_changed(icon: Texture2D) -> void:
	upgrade.icon = icon


func _on_upgrade_logic_changed(script: Script) -> void:
	pass
