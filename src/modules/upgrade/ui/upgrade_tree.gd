extends Node2D
## The folder with all the upgrades.tres files
@export_dir var upgrade_folder_path: String
@export var center_texture: Texture2D
@onready var line_texure: Texture2D = load("res://assets/ui/upgrade_tree/line.png")
var ui_upgrade_template = preload("res://modules/upgrade/ui/ui_upgrade_template.tscn")
var upgrades: Array[BaseUpgrade]
var ui_spacer_scale: float = 0.2


# Called when the node enters the scene tree for the first time.
func _ready():
	_read_upgrade_files()
	_load_upgrades()


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
						print("Loaded:", resource)
						upgrades.append(resource)
				file_name = dir.get_next()
			dir.list_dir_end()


func _load_upgrades():
	for upgrade_data in upgrades:
		var instance = ui_upgrade_template.instantiate()
		$Upgrades.add_child(instance)
		instance.position = upgrade_data.position * Vector2(ui_spacer_scale, ui_spacer_scale)
		instance.base_upgrade = upgrade_data
		instance.reload_base_upgrade_data()
		#if upgrade_data.icon != null:
		#	instance.get_node("Icon").texture = upgrade_data.icon
		for unlock in upgrade_data.unlocks:
			var line = Line2D.new()
			$Lines.add_child(line)
			line.add_point(instance.position)
			line.add_point(unlock.position * Vector2(ui_spacer_scale, ui_spacer_scale))
			line.texture = line_texure
			line.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
			line.texture_mode = Line2D.LINE_TEXTURE_TILE
			line.width = 10
