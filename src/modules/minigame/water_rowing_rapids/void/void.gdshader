shader_type canvas_item;
render_mode blend_mul, unshaded;

uniform sampler2D screen_tex:hint_screen_texture;

void fragment() {
	COLOR = texture(screen_tex, SCREEN_UV);
}
