shader_type canvas_item;

uniform float pulse_intensity = 0.12;
uniform float wobble_offset = 18.0;
uniform float radius_offset_intensity = 0.2;
uniform sampler2D gradient:source_color;

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	float radius = 1.0 - pulse_intensity - radius_offset_intensity;
	radius = (sin(TIME + world_pos.x / wobble_offset) * pulse_intensity)+radius;
	vec2 corrected_uv = UV;
	corrected_uv.y -= 0.5;
	corrected_uv.x -= 0.5 - sin(world_pos.y / wobble_offset)*radius_offset_intensity/2.0;
	float dst = length(corrected_uv); // reuse t
	COLOR.rgb = COLOR.rgb + texture(gradient, vec2(dst / radius * 2.0 , 0.0)).rgb;
	COLOR.a = step(dst, radius/2.0);
}
