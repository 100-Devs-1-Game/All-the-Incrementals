shader_type spatial;
render_mode unshaded, depth_test_disabled;

const vec3 magic = vec3(1.06711056f, 1.00583715f, 100.9829189f);
uniform vec4 color: source_color = vec4(1.0, 1.0, 1.0, 0.5);

void fragment() {
	ALBEDO = color.rgb;
	if (color.a < 0.001 || color.a < fract(magic.z * fract(dot(FRAGCOORD.xy, magic.xy)))) {
		discard;
	}
}
