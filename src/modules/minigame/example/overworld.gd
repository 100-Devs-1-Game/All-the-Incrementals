extends CanvasLayer

@export var minigames: Array[MinigameData]

@onready var vbox: VBoxContainer = $VBoxContainer


func _ready() -> void:
	# Create buttons for all minigames
	for minigame in minigames:
		var button := Button.new()
		button.text = minigame.display_name
		vbox.add_child(button)
		button.pressed.connect(start_minigame.bind(minigame))


func start_minigame(data: MinigameData):
	create_scene_loader(data)

	get_tree().change_scene_to_packed(data.minigame_scene)


# Create a temporary autoload to transfer data between scenes
# In our game the SceneLoader will be a proper autoload
func create_scene_loader(data: MinigameData):
	var node := Node.new()
	node.name = "Scene Loader"
	node.set_script(load("res://modules/minigame/example/scene_loader.gd"))
	var loader: ExampleSceneLoader = node
	loader.data = data
	get_tree().root.add_child(node)
