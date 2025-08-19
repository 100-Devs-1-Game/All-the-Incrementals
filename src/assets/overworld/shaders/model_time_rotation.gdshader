shader_type spatial;

uniform sampler2D wind_noise;

uniform sampler2D albedo_texture: hint_default_white;
uniform vec3 albedo_color: source_color = vec3(1.0);
uniform float roughness = 1.0;
uniform float metallic = 0.5;
uniform float specular = 0.1;
uniform float spin_amount = 0.1;
uniform bool clockwise = true;

group_uniforms time_based_rotation;
uniform bool use_time = false;
uniform float spin_speed = 2.0;

group_uniforms rotate;
uniform bool rotate_x = false;
uniform bool rotate_y = false;
uniform bool rotate_z = false;

mat3 rotateX(float theta) {
	float cosa = cos(theta);
	float sina = sin(theta);

	//Y rotation
	mat3 rot_x  = mat3(
	   vec3(1.0, 0.0, 0.0),
	   vec3(0.0, cosa, -sina),
	   vec3(0.0, sina, cosa)
	);

	return rot_x;
}


mat3 rotateY(float theta) {
	float cosa = cos(theta);
	float sina = sin(theta);


	//Y rotation
	mat3 rot_y  = mat3(
	   vec3(cosa, 0.0, sina),
	   vec3(0.0, 1.0, 0.0),
	   vec3(-sina, 0.0, cosa)
	);

	return rot_y;
}


mat3 rotateZ(float theta) {
	float cosa = cos(theta);
	float sina = sin(theta);

	//Y rotation
	mat3 rot_z  = mat3(
	   vec3(cosa,-sina, 0.0),
	   vec3(sina, cosa, 0.0),
	   vec3(0.0, 0.0, 1.0)
	);

	return rot_z;
}

void vertex() {
	float rotation = spin_amount;

    float freq = 0.01;
    float amp = 1.5;

	float wind = texture(wind_noise, NODE_POSITION_WORLD.xz * 0.0025).r;
    float wind_multiplier = amp * sin(wind * freq + TIME * spin_speed);
	wind = 1.0 - (wind * 2.0);
	wind *= wind_multiplier;

	float time_rotation = TIME * spin_speed * wind * float(use_time);

	float rot_x = float(rotate_x);
	float rot_y = float(rotate_y);
	float rot_z = float(rotate_z);

	mat3 rotation_matrix = rotateX((rotation + time_rotation) * rot_x) * rotateY((rotation + time_rotation) * rot_y) * rotateZ((rotation + time_rotation) * rot_z);
	vec3 rotated_vertex = rotation_matrix * VERTEX;
	vec3 rotated_normals = rotation_matrix * NORMAL;

	VERTEX = rotated_vertex;
	NORMAL = rotated_normals;
}

void fragment() {
	vec3 color = texture(albedo_texture, UV).rgb * albedo_color;
    METALLIC = metallic;
	ALBEDO = color;
}
