shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_disabled, unshaded;

uniform sampler2D texture_albedo : source_color, filter_nearest;


void fragment() {
	vec4 albedo_tex = texture(texture_albedo, UV);
	ALBEDO = albedo_tex.rgb;
	EMISSION = albedo_tex.rgb * albedo_tex.a;
	ALPHA *= albedo_tex.a * COLOR.a;
}
