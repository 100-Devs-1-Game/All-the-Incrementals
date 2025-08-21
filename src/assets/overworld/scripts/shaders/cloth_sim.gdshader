shader_type spatial;
render_mode blend_mix, depth_prepass_alpha;

uniform sampler2D albedo_texture;
uniform sampler2D normal_texture;
uniform vec4 albedo_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // color picker

uniform float sway_strength = 0.1;
uniform float sway_speed    = 2.0;
uniform float y_top         = 1.0;
uniform float y_bottom      = -1.0;
uniform float alpha_cutoff  = 0.1;

void vertex() {
    float mask = pow(smoothstep(y_top, y_bottom, VERTEX.y), 2.0);
    VERTEX.x += sin(TIME * sway_speed + VERTEX.y * 4.0) * sway_strength * mask;
}

void fragment() {
    vec4 tex_col = texture(albedo_texture, UV);
    vec4 final_col = tex_col * albedo_color; // Apply tint

    if (final_col.a < alpha_cutoff) {
        discard;
    }

    ALBEDO = final_col.rgb;
    ALPHA  = final_col.a;
    NORMAL = texture(normal_texture, UV).xyz * 2.0 - 1.0;
}
