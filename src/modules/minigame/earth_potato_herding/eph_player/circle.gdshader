shader_type canvas_item;

uniform float min_radius: hint_range(0.0, 100.0, 0.1) = 20.0;
uniform float size: hint_range(0.0, 100.0, 0.1) = 20.0;
uniform vec4 color: source_color;

void fragment() {
	vec4 col = color;

	vec2 dif = UV-vec2(1,1)*0.5;
	float dist = (pow(dif.x,2)+pow(dif.y,2))/TEXTURE_PIXEL_SIZE.x;

	if (dist > min_radius+size){
		col.a = 0.0;
	}

	if (dist < min_radius){
		col.a = 0.0;
	}

	COLOR = col;
}
