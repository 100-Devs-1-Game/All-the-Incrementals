shader_type spatial;

uniform sampler2D texture_albedo;
uniform float tile_scale = 1.0;          // world units per tile
uniform float blend_sharpness = 4.0;     // triplanar blend power
uniform float rot_max_deg = 25.0;        // max random rotation per tile
uniform float rot_seed = 43758.5453;     // change to reshuffle

varying vec3 world_position;
varying vec3 world_normal;

float hash31(vec3 p) {
    // fast, stable hash in [0,1)
    return fract(sin(dot(p, vec3(12.9898, 78.233, 37.719))) * rot_seed);
}

mat2 rot2(float a) {
    float c = cos(a), s = sin(a);
    return mat2(vec2(c, -s), vec2(s, c));
}

void vertex() {
    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    world_normal = normalize(mat3(MODEL_MATRIX) * NORMAL);
}

void fragment() {
    vec3 n = normalize(world_normal);
    vec3 an = abs(n);

    float w_top  = pow(an.y, blend_sharpness);
    float w_x    = pow(an.x, blend_sharpness);
    float w_z    = pow(an.z, blend_sharpness);
    float w_sum  = w_top + w_x + w_z;
    w_top /= w_sum; w_x /= w_sum; w_z /= w_sum;

    // Tile index in 3D (same index drives all projections ⇒ no seams)
    vec3 idx3 = floor(world_position / max(0.0001, tile_scale));
    float a = radians(rot_max_deg) * (hash31(idx3) * 2.0 - 1.0); // [-max,+max]

    // --- TOP (y) projection ---
    vec2 p_top   = world_position.xz / tile_scale;
    vec2 cell_t  = floor(p_top);
    vec2 local_t = fract(p_top) - 0.5;
    local_t = rot2(a) * local_t;
    vec2 uv_top  = (local_t + 0.5) + cell_t;

    // --- X-side projection ---
    vec2 p_x     = world_position.zy / tile_scale; // z up, y right
    vec2 cell_x  = floor(p_x);
    vec2 local_x = fract(p_x) - 0.5;
    local_x = rot2(a) * local_x;
    vec2 uv_x    = (local_x + 0.5) + cell_x;

    // --- Z-side projection ---
    vec2 p_z     = world_position.xy / tile_scale;
    vec2 cell_z  = floor(p_z);
    vec2 local_z = fract(p_z) - 0.5;
    local_z = rot2(a) * local_z;
    vec2 uv_z    = (local_z + 0.5) + cell_z;

    vec3 c_top = texture(texture_albedo, uv_top).rgb;
    vec3 c_x   = texture(texture_albedo, uv_x).rgb;
    vec3 c_z   = texture(texture_albedo, uv_z).rgb;

    ALBEDO = c_top * w_top + c_x * w_x + c_z * w_z;
}
