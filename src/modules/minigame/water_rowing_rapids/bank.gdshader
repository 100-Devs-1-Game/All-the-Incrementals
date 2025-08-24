shader_type canvas_item;

uniform float vertical_amplitude = 0.5;
uniform float horizontal_amplitude = 0.5;
uniform float time_scale = 1.0;
uniform float horizontal_time_scale = 1.0;
uniform float horizontal_offset = 1.5;

varying vec4 mod_color;

void vertex() {
	mod_color = COLOR;
}

void fragment() {
	float revpulse = 1.0 - vertical_amplitude;
	vec2 resampled_uv = vec2(UV.x, UV.y / revpulse - vertical_amplitude);
	resampled_uv.y = resampled_uv.y + (
		(sin(TIME + time_scale + UV.x * horizontal_offset) + 1.0
	) * vertical_amplitude / 2.0);
	resampled_uv.x = resampled_uv.x + (
		sin(TIME * horizontal_time_scale + UV.x * horizontal_offset) + 1.0
		) / 2.0 * horizontal_amplitude;
	if (resampled_uv.y > 1.0 || resampled_uv.y < 0.0){
		COLOR = vec4(0.0);
	}
	else {
		COLOR = texture(TEXTURE, resampled_uv) * mod_color;
	}
}
