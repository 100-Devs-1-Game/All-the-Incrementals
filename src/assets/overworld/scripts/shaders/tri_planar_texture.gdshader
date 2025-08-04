shader_type spatial;

uniform sampler2D texture_albedo;
uniform float tile_scale = 1.0;
uniform float blend_sharpness = 4.0;

varying vec3 world_position;
varying vec3 world_normal;

void vertex() {
    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    world_normal = normalize(mat3(MODEL_MATRIX) * NORMAL);
}

void fragment() {
    vec3 n = normalize(world_normal);
    vec3 abs_normal = abs(n);

    float top_weight = pow(abs_normal.y, blend_sharpness);
    float side_x_weight = pow(abs_normal.x, blend_sharpness);
    float side_z_weight = pow(abs_normal.z, blend_sharpness);
    float total_weight = top_weight + side_x_weight + side_z_weight;

    top_weight /= total_weight;
    side_x_weight /= total_weight;
    side_z_weight /= total_weight;

    vec2 uv_top = world_position.xz / -tile_scale;
    vec2 uv_side_x = world_position.zy / -tile_scale;
    vec2 uv_side_z = world_position.xy / -tile_scale;

    vec2 uv = (top_weight > side_x_weight && top_weight > side_z_weight) ? uv_top :
               (side_x_weight > side_z_weight) ? uv_side_x : uv_side_z;
    ALBEDO = texture(texture_albedo, uv).rgb;
}
