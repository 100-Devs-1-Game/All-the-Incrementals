@tool
extends GraphNode
class_name UpgradeEditor

@export var upgrade: MinigameUpgrade

@onready var info: RichTextLabel =  %Information

func _ready() -> void:
	if upgrade:
		position_offset = upgrade.position
		set_fields_from_upgrade()


func _process(delta: float) -> void:
	set_fields_from_upgrade()


func set_fields_from_upgrade() -> void:
	assert(upgrade)
	title = upgrade.name
	$Control/Icon.texture = upgrade.icon

	info.text = ""

	if !upgrade.logic:
		add_info_error("MISSING LOGIC")

	if upgrade.cost_arr.is_empty():
		add_info_error("MISSING COSTS")

	if upgrade.get_max_level() <= 0:
		add_info_error("MISSING MAX LEVEL")

	if !upgrade.effect_modifier_arr:
		add_info_error("MISSING EFFECT MODIFIERS")

	if upgrade.effect_modifier_arr.size() != upgrade.cost_arr.size():
		add_info_error("MISMATCHED EFFECTS WITH COSTS")

	if upgrade.flavor == "":
		add_info_warning("MISSING FLAVOR")

	if upgrade.description_prefix == "" || upgrade.description_suffix:
		add_info_warning("MISSING DESCRIPTION")


func add_info_error(msg: String) -> void:
	add_info("[color=red]%s[/color]" % msg)


func add_info_warning(msg: String) -> void:
	add_info("[color=yellow]%s[/color]" % msg)


func add_info(msg: String) -> void:
	if info.text != "":
		info.append_text("\n")

	info.append_text("%s\n" %msg)
