shader_type canvas_item;

uniform vec2 base_drop;
uniform sampler2D foam: repeat_enable;
uniform sampler2D pulse: repeat_enable;
varying vec2 screen_pos;

void vertex() {
	screen_pos = CANVAS_MATRIX[3].rg;

}

void fragment() {
	vec2 offset = screen_pos / base_drop;
	vec4 foam_color = texture(foam, UV);
	COLOR = vec4(mix(texture(TEXTURE, UV + offset).rgb, foam_color.rgb, foam_color.a), 1.0);
}
