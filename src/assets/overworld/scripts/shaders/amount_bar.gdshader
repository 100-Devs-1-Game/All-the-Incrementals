shader_type spatial;

uniform float fill_level : hint_range(0.0, 1.0) = 1.0;
uniform vec3 fill_color : source_color = vec3(0.0, 1.0, 0.0);
uniform vec3 background_color : source_color = vec3(0.0, 0.0, 0.0); // <── added
uniform float glow_strength : hint_range(0.0, 10.0) = 10.0;
uniform bool flip_direction = false;
uniform float gradient_sharpness : hint_range(0.001, 1.0) = 0.025;
uniform float fill_offset : hint_range(0.0, 10.0) = 0.0;
uniform float black_specular : hint_range(0.0, 1.0) = 0.5;

render_mode blend_mix, cull_disabled, depth_draw_opaque;

void fragment() {
    float uv_y = flip_direction ? (1.0 - UV.y) : UV.y;

    float time = TIME + fill_offset;
    float wobble = sin(time * 2.0) * 0.01;
    float animated_fill = clamp(fill_level + wobble, 0.0, 1.0);

    float edge_start = animated_fill - gradient_sharpness;
    float edge_end = animated_fill + gradient_sharpness;

    float gradient = 1.0 - smoothstep(edge_start, edge_end, uv_y);

    vec3 final_color = mix(background_color, fill_color, gradient);

    ALBEDO = final_color;
    ALPHA = 1.0;
    EMISSION = final_color * glow_strength;
    SPECULAR = mix(black_specular, 1.0, gradient);
}
