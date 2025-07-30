@tool
extends GraphNode
class_name UpgradeEditor

@export var upgrade: MinigameUpgrade


func set_fields_from_upgrade() -> void:
	title = upgrade.name
	position_offset = upgrade.position
	$Control/Icon.texture = upgrade.icon
