class_name PlayerState
extends Resource

@export var inventory: EssenceInventory

# Dictionary mapping MinigameData resource path to an array of their latest 5 scores
@export var highscores: Dictionary[StringName, Array]
