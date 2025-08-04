shader_type spatial;

uniform float sway_strength = 0.1;
uniform float sway_speed = 2.0;

// length Y range (adjust these based on your mesh bounds)
uniform float y_top = 1.0;   // tip
uniform float y_bottom = -1.0; // center hanging

void vertex() {
    // Normalize Y position from tip to bottom (0 to 1)
    float mask = smoothstep(y_top, y_bottom, VERTEX.y);

    // Optional: sharpen center-only motion
    mask = pow(mask, 2.0);

    // Sway offset (change axis if you want sideways sway instead of forward)
    float sway = sin(TIME * sway_speed + VERTEX.y * 4.0) * sway_strength;

    // Apply only where mask is strong
    VERTEX.x += sway * mask;
}
