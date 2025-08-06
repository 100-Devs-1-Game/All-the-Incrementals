shader_type spatial;

uniform float time_speed : hint_range(0.0, 10.0) = 1.0;
uniform float swirl_strength : hint_range(0.0, 1.0) = 0.1;
uniform float swirl_freq = 5.0;
uniform float emission_strength : hint_range(0.0, 100.0) = 100.0;

uniform vec3 bottom_color : source_color = vec3(1.0, 0.3, 0.0);
uniform vec3 top_color : source_color = vec3(1.0, 1.0, 0.2);

uniform sampler2D albedo_texture : source_color;

render_mode unshaded, blend_mix, cull_disabled, depth_draw_opaque;

void fragment() {
    vec2 uv = UV;
    vec2 centered = uv - vec2(0.5);
    float angle = swirl_strength * sin(TIME * time_speed + length(centered) * swirl_freq);
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(vec2(c, s), vec2(-s, c));
    centered = rot * centered;
    uv = centered + vec2(0.5);

    vec4 tex_color = texture(albedo_texture, uv);
    float height_factor = uv.y;
    vec3 gradient_color = mix(bottom_color, top_color, height_factor);

    ALBEDO = tex_color.rgb;
    ALPHA = tex_color.a;
    EMISSION = gradient_color * tex_color.a * emission_strength;
}
