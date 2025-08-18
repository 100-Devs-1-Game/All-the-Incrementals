shader_type canvas_item;
render_mode blend_sub, unshaded;

uniform sampler2D screen_tex:hint_screen_texture;

void fragment() {
	COLOR.rgb = vec3(1.0) - texture(screen_tex, SCREEN_UV).rgb;
}
