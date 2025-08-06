shader_type spatial;

render_mode blend_mix, cull_disabled, depth_draw_opaque;

uniform float time_speed : hint_range(0.0, 10.0) = 1.0;
uniform float swirl_strength : hint_range(0.0, 1.0) = 0.1;
uniform float swirl_freq = 5.0;

uniform sampler2D albedo_texture : source_color;
uniform sampler2D normal_texture : hint_normal;

uniform float normal_strength : hint_range(0.0, 2.0) = 1.0;
uniform float emission_strength : hint_range(0.0, 10.0) = 0.3;

void fragment() {
    vec2 uv = UV;

    // Swirl distortion
    vec2 centered = uv - vec2(0.5);
    float angle = swirl_strength * sin(TIME * time_speed + length(centered) * swirl_freq);
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(vec2(c, s), vec2(-s, c));
    centered = rot * centered;
    uv = centered + vec2(0.5);

    // Sample albedo
    vec4 tex_color = texture(albedo_texture, uv);
    ALBEDO = tex_color.rgb;
    ALPHA = tex_color.a;

    // Sample normal map and apply distortion
    vec3 normal_tex = texture(normal_texture, uv).rgb;
    normal_tex = normalize(normal_tex * 2.0 - 1.0);
    NORMAL = mix(NORMAL, normal_tex, normal_strength);

    // Emission for glow/fake reflection
    EMISSION = tex_color.rgb * emission_strength;
}
