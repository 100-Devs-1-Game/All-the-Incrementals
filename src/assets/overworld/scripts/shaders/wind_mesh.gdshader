shader_type spatial;

uniform sampler2D albedo_texture : source_color;
uniform sampler2D normal_texture : hint_normal;

uniform float sway_strength : hint_range(0.0, 1.0) = 0.1;
uniform float sway_speed : hint_range(0.0, 10.0) = 1.0;
uniform float sway_scale : hint_range(0.0, 10.0) = 1.0;

void vertex() {
	float sway = sin(TIME * sway_speed + VERTEX.y * sway_scale) * sway_strength;
	VERTEX.x += sway;
}

void fragment() {
	ALBEDO = texture(albedo_texture, UV).rgb;

	// Sample and transform normal map from tangent space to world space
	vec3 n = texture(normal_texture, UV).rgb;
	n = n * 2.0 - 1.0; // Convert from [0,1] to [-1,1]
	NORMAL = normalize(TANGENT * n.x + BINORMAL * n.y + NORMAL * n.z);
}
