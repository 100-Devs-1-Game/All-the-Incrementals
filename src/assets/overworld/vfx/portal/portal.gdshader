shader_type spatial;

// Classic Perlin noise function (2D)
float noise(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float smoothNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(mix(noise(i + vec2(0.0, 0.0)), noise(i + vec2(1.0, 0.0)), u.x),
               mix(noise(i + vec2(0.0, 1.0)), noise(i + vec2(1.0, 1.0)), u.x), u.y);
}

float perlinNoise(vec2 p, float octaves, float scale, float speed) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(TIME * speed); // Animate based on speed parameter
    p *= scale; // Apply scale to control frequency
    for (int i = 0; i < int(octaves); ++i) {
        v += a * smoothNoise(p + shift);
        p *= 2.0;
        a *= 0.5;
    }
    return v;
}

// Rotate UV function
vec2 rotateUV(vec2 uv, vec2 pivot, float angle) {
    mat2 rotation = mat2(vec2(sin(angle), -cos(angle)),
                         vec2(cos(angle), sin(angle)));
    uv -= pivot;
    uv = uv * rotation;
    uv += pivot;
    return uv;
}

uniform float size : hint_range(0.0, 1.0) = 0.2;
uniform float size_inner : hint_range(0.1, 1.0) = 0.2;

uniform sampler2D inner; // Texture for the portal interior

uniform vec4 portalFrameColor : source_color;
uniform vec4 portalHighlightColor : source_color;

uniform float distortion_strength : hint_range(0.0, 0.5) = 0.1; // How intense the wobble is
uniform float distortion_speed : hint_range(0.1, 5.0) = 1.0;   // How fast the wobble animates

// Spin controls for inner texture
uniform int spin_axis : hint_enum("X", "Y", "Z") = 0; // 0 = X, 1 = Y, 2 = Z
uniform float spin_speed : hint_range(0.0, 100.0) = 1.0; // Speed of rotation

// Perlin noise customization
uniform float noise_scale : hint_range(1.0, 20.0) = 5.0; // Controls the size/frequency of the noise
uniform float noise_speed : hint_range(0.0, 5.0) = 0.1;  // Controls the animation speed of the noise
uniform float noise_octaves : hint_range(1.0, 8.0) = 6.0; // Controls the detail level of the noise

void fragment() {
    float dist = length(UV - vec2(0.5, 0.5));

    vec2 nuv = UV;
    nuv = rotateUV(UV, vec2(0.5), 45.0 * TIME * 0.01);
    nuv.x += (TIME * 0.1);
    nuv.y -= (TIME * 0.1);

    float ntexel = perlinNoise(nuv, noise_octaves, noise_scale, noise_speed);

    float a = smoothstep(size, size - 0.04, dist);
    float a2 = smoothstep(size, (ntexel * 0.10) + (size - size_inner), dist);

    vec4 result = mix(portalHighlightColor, portalHighlightColor, a);
    ALPHA = a;

    if (a == 1.0) {
        // Compute distorted UVs for wobbling portal effect
        vec2 inner_uv = UV;
        
        // Noise-based distortion (organic turbulence) using Perlin noise
        vec2 noise_distort = (vec2(perlinNoise(nuv * 0.5 + vec2(TIME * 0.05 * distortion_speed), noise_octaves, noise_scale, noise_speed)) - 0.5) * distortion_strength;
        
        // Sine/cosine wave distortion (wavy ripple)
        float wave_x = sin(TIME * 2.0 * distortion_speed + UV.y * 10.0) * 0.05 * distortion_strength;
        float wave_y = cos(TIME * 3.0 * distortion_speed + UV.x * 8.0) * 0.03 * distortion_strength;
        
        inner_uv += noise_distort + vec2(wave_x, wave_y);
        
        // Apply spin rotation based on selected axis
        float angle = TIME * spin_speed;
        if (spin_axis == 0) { // X-axis spin (roll)
            inner_uv = rotateUV(inner_uv, vec2(0.5), angle);
        } else if (spin_axis == 1) { // Y-axis spin (yaw)
            inner_uv = rotateUV(inner_uv, vec2(0.5), angle);
            // Note: Y-axis rotation in 2D UV space is the same as X for a flat plane; adjust mesh for true 3D if needed
        } else if (spin_axis == 2) { // Z-axis spin (standard rotation)
            inner_uv = rotateUV(inner_uv, vec2(0.5), angle);
        }
        
        // Sample the inner texture with distorted and spun UVs
        result = texture(inner, inner_uv);
    }

    if (a2 < 0.2) {
        result = portalHighlightColor;
    }

    result = mix(portalFrameColor, result, a2);

    ALBEDO = result.rgb;
    EMISSION = ALBEDO;
}