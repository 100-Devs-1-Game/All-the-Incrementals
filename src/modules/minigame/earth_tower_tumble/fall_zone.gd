extends Area2D

@onready var inst = get_parent()

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	

func _on_body_entered(body: Node) -> void:
	inst.life_lost()
