extends AnimatedSprite3D

@export var shader_material: ShaderMaterial
@export var frames: SpriteFrames


func _process(_delta: float) -> void:
	if shader_material and frames:
		var tex: Texture2D = frames.get_frame_texture(animation, frame)
		shader_material.set_shader_parameter("albedo_texture", tex)
