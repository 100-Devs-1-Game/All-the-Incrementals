extends Control

@export var for_text: String = ""
@export var buttons: Array[PlaceholderButton] = []


func _ready() -> void:
	if for_text != "":
		$PlaceholderFor.text = for_text + "\ngoes here"
	else:
		$PlaceholderFor.text = ""

	for button in buttons:
		var new_button: Button = Button.new()
		new_button.text = button.label
		new_button.connect("pressed", Callable(self, "_change_scene").bind(button.scene_path))
		$VBoxContainer.add_child(new_button)
		var name = button.label


func _change_scene(scene_path: String) -> void:
	if scene_path != "":
		print("Changing scene to: " + scene_path)
		get_tree().change_scene_to_packed(load(scene_path))
	else:
		print("No scene_path defined for placeholder button target")
