shader_type canvas_item;

uniform vec2 base_drop;
uniform sampler2D foam: repeat_enable;

uniform sampler2D flow_map: repeat_enable;
uniform float flow_map_scale = 10.0;
uniform float flow_speed_scale = 30.0;
uniform float flow_strength = 1.0;

varying vec2 screen_pos;

void vertex() {
	screen_pos = CANVAS_MATRIX[3].rg;
	//UV=UV*uv1_scale.xy+uv1_offset.xy;
}

void fragment() {
	vec2 offset = screen_pos / base_drop;

	float c = TIME / flow_speed_scale;
	vec4 flow_offset = texture(flow_map, vec2(UV.x + c, UV.y + c)/flow_map_scale) * flow_strength;
	vec2 flow_uv = UV + flow_offset.xy;

	vec4 foam_color = texture(foam, flow_uv);

	// guh
	flow_offset = texture(flow_map, vec2(UV.x + offset.x + c, UV.y + offset.y + c)/flow_map_scale)
			* flow_strength;
	flow_uv = UV + flow_offset.zx;
	COLOR = vec4(mix(texture(TEXTURE, flow_uv + offset).rgb, foam_color.rgb, foam_color.a), 1.0);
}
