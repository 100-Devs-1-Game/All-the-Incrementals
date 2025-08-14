class_name WTFBackgroundSprite
extends AnimatedSprite2D

@onready var parallax_component: WTFParallaxComponent = %WtfParallaxComponent


func _ready() -> void:
	assert(sprite_frames)

	scale *= parallax_component.movement_multiplier
	reset_physics_interpolation()

	play()
