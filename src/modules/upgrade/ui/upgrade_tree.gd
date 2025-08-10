class_name UpgradeTree
extends Node
## The folder with all the upgrades.tres files
@export_dir var upgrade_folder_path: String
@export var center_texture: Texture2D
var ui_upgrade_template = preload("res://modules/upgrade/ui/ui_upgrade_template.tscn")
var upgrades: Array[BaseUpgrade]
var ui_spacer_scale: float = 0.2
var current_upgrade: BaseUpgrade
var essence_type: String
@onready var line_texture: Texture2D = load("res://assets/ui/upgrade_tree/line.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	if SceneLoader.has_current_minigame():
		upgrades = SceneLoader.get_current_minigame().get_all_upgrades()
		essence_type = SceneLoader.get_current_minigame().output_essence.name
	else:
		_read_upgrade_files()
	_load_upgrades()


func change_display(
	upgrade: BaseUpgrade,
	name_text: String,
	cost_text: String,
	level_text: String,
	description: String
) -> void:
	current_upgrade = upgrade
	$CanvasLayer/UI/UpgradeInfoContainer.show()
	$CanvasLayer/UI/UpgradeInfoContainer/PanelContainer/LContainer/NameInfo.text = (
		"[font_size=80]" + name_text
	)
	$CanvasLayer/UI/UpgradeInfoContainer/PanelContainer/RContainer/MC/HC/CostInfo.text = (
		"[font_size=50]" + cost_text
	)
	$CanvasLayer/UI/UpgradeInfoContainer/PanelContainer/RContainer/LevelInfo.text = (
		"[font_size=80]" + level_text
	)
	$CanvasLayer/UI/UpgradeInfoContainer/PanelContainer/LContainer/DescriptionInfo.text = (
		"[font_size=50]" + description
	)


func _read_upgrade_files():
	if upgrade_folder_path != "":
		var dir = DirAccess.open(upgrade_folder_path)
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if file_name.ends_with(".tres"):
					var full_path = upgrade_folder_path.path_join(file_name)
					var resource = load(full_path)
					if resource:
						upgrades.append(resource)
				file_name = dir.get_next()
			dir.list_dir_end()


func _input(event: InputEvent) -> void:
	if SceneLoader.has_current_minigame() and event.is_action_pressed("exit_menu"):
		SceneLoader.start_minigame(SceneLoader.get_current_minigame())


func _load_upgrades():
	for upgrade_data in upgrades:
		var instance = ui_upgrade_template.instantiate()
		$Upgrades.add_child(instance)
		instance.position = upgrade_data.position * Vector2(ui_spacer_scale, ui_spacer_scale)
		instance.position = Vector2(instance.position.y, -instance.position.x)
		instance.base_upgrade = upgrade_data
		instance.init(self, essence_type)
		instance.reload_base_upgrade_data()
		#if upgrade_data.icon != null:
		#	instance.get_node("Icon").texture = upgrade_data.icon
		for unlock in upgrade_data.unlocks:
			var line = Line2D.new()
			$Lines.add_child(line)
			line.add_point(instance.position)
			#line.add_point(unlock.position * Vector2(ui_spacer_scale, ui_spacer_scale))
			line.add_point(
				(
					Vector2(unlock.position.y, -unlock.position.x)
					* Vector2(ui_spacer_scale, ui_spacer_scale)
				)
			)
			line.texture = line_texture
			line.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
			line.texture_mode = Line2D.LINE_TEXTURE_TILE
			line.width = 10


func _on_fill_button_fill_complete(fill_button: FillButton) -> void:
	if current_upgrade.can_afford_next_level():
		current_upgrade.level_up()
		fill_button.trigger_again()
