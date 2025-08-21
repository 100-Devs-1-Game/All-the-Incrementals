shader_type spatial;
render_mode cull_back, specular_disabled;

uniform sampler2D texture_albedo: source_color;
uniform float alpha_scissor_threshold: hint_range(0.0, 1.0, 0.001) = 0.01;
uniform vec3 highlight_band_color: source_color = vec3(0.5);
uniform float highlight_band_period;
uniform float highlight_band_width = 0.5;


void fragment() {
	vec4 tex_albedo = texture(texture_albedo, UV);
	if(mod(UV.x + UV.y - TIME, highlight_band_period) < highlight_band_width){
		EMISSION = highlight_band_color;
	}
	ALBEDO = tex_albedo.rgb;
	ALPHA = tex_albedo.a;
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;
}
