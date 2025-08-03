shader_type canvas_item;

uniform vec4 shape_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 background_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float shape_size : hint_range(0.01, 0.5) = 0.05;
uniform float shape_density : hint_range(1.0, 50.0) = 10.0;
uniform float randomness : hint_range(0.0, 1.0) = 0.5;
uniform float move_speed : hint_range(0.0, 2.0) = 0.2;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float diamond_dist(vec2 p) {
    return abs(p.x) + abs(p.y);
}

float square_dist(vec2 p) {
    return max(abs(p.x), abs(p.y));
}

void fragment() {
    vec2 uv = UV;

    vec2 grid_uv = uv * shape_density;

    vec2 cell = floor(grid_uv);
    vec2 local_uv = fract(grid_uv);

    vec2 centered_uv = local_uv - 0.5;

    float rnd_shape = hash(cell);
    float rnd1 = hash(cell + 1.3);
    float rnd2 = hash(cell + 2.7);

    vec2 animated_offset = vec2(
        sin(TIME * move_speed + rnd1 * 6.2831),
        cos(TIME * move_speed + rnd2 * 6.2831)
    ) * 0.25 * randomness;

    vec2 shape_uv = centered_uv - animated_offset;

    float dist;
    if (rnd_shape < 0.33) {
        dist = length(shape_uv);
    } else if (rnd_shape < 0.66) {
        dist = diamond_dist(shape_uv);
    } else {
        dist = square_dist(shape_uv);
    }

    if (dist < shape_size) {
        COLOR = shape_color;
    } else {
        COLOR = background_color;
    }
}
