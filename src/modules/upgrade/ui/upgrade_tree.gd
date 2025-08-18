class_name UpgradeTree
extends Node
## The folder with all the upgrades.tres files
@export_dir var upgrade_folder_path: String

## hacky way to display overworld upgrades
@export var shrine_data: MinigameData

@export var minigame_upgrade_template: PackedScene
@export var shrine_upgrade_template: PackedScene

var upgrades: Array[BaseUpgrade]
var ui_spacer_scale: float = 0.2
var current_upgrade: BaseUpgrade
var essence_type: String
var minigame: MinigameData

@onready var line_texture: Texture2D = load("res://assets/ui/upgrade_tree/line.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	assert(shrine_data != null)

	$CanvasLayer/UI/UpgradeInfoContainer.hide()

	if SceneLoader.has_current_minigame():
		minigame = SceneLoader.get_current_minigame()
	else:
		minigame = shrine_data

	if minigame:
		upgrades = minigame.get_all_upgrades()
		if minigame.output_essence:
			essence_type = minigame.output_essence.name
		for upgrade_root_node in minigame.upgrade_tree_root_nodes:
			upgrade_root_node.unlocked = true
			if upgrade_root_node.get_level_index() >= upgrade_root_node.unlock_level_index:
				_unlock_children(upgrade_root_node.unlocks)
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
	$ClickAudio.play(0.0)
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
		"[font_size=30]" + description
	)
	$CanvasLayer/UI/UpgradeInfoContainer/MarginButton/FillButton/UpgradeButton.visible = !(
		current_upgrade.is_maxed_out()
	)
	$CanvasLayer/UI/UpgradeInfoContainer/MarginButton/FillButton/NormalColor.visible = !(
		current_upgrade.is_maxed_out()
	)
	$CanvasLayer/UI/UpgradeInfoContainer/MarginButton/FillButton.to_poor = !(
		current_upgrade.can_afford_next_level()
	)
	if !current_upgrade.unlocked:
		$CanvasLayer/UI/UpgradeInfoContainer.hide()


func _unlock_children(unlocks: Array[Resource]) -> void:
	if unlocks == null || unlocks.is_empty():
		return
	for child in unlocks:
		child.unlocked = true
		if child.get_level_index() >= child.unlock_level_index:
			_unlock_children(child.unlocks)


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
		var template: PackedScene
		if SceneLoader.has_current_minigame():
			template = minigame_upgrade_template
		else:
			template = shrine_upgrade_template

		var instance = template.instantiate()
		$Upgrades.add_child(instance)
		instance.position = upgrade_data.position * Vector2(ui_spacer_scale, ui_spacer_scale)
		instance.position = Vector2(instance.position.y, -instance.position.x)
		instance.base_upgrade = upgrade_data
		if not minigame.output_essence:
			essence_type = upgrade_data.base_cost.slots[0].essence.name

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
		Player.pay_upgrade_cost(current_upgrade.get_next_level_cost())
		current_upgrade.level_up()
		EventBus.ui_upgrade_bought.emit(current_upgrade)
		if !current_upgrade.is_maxed_out():
			fill_button.trigger_again()
	else:
		fill_button.reset()
		fill_button.to_poor = true
