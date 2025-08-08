shader_type spatial;

render_mode unshaded;

uniform float flameTaperFactor = 5.4;
uniform float flameTipAmplitudeX = 0.025;
uniform float flameTipAmplitudeZ = 0.025;
uniform float flameTipFrequencyX = 10.0;
uniform float flameTipFrequencyZ = 10.0
;

uniform vec3 topColor : source_color = vec3(1.0, 0.0, 0.0);
uniform vec3 bottomColor : source_color = vec3(1.0, 1.0, 0.0);
uniform vec3 fresnelColor : source_color = vec3(0.0, 1.0, 1.0);

uniform float fresnelAmount : hint_range(0, 100) = 5.0;
uniform float fresnelIntensity : hint_range(0, 100) = 2.0;
uniform float baseAlpha : hint_range(0, 1) = 0.0;
uniform float colorFadeHeight : hint_range(0, 1) = 0.4;
uniform float darkZoneRadius : hint_range(0, 1) = 0.8;
uniform float flickerSpeed : hint_range(0, 100) = 3.0;

vec3 fresnelGlow(float amount, float intensity, vec3 color, vec3 normal, vec3 view) {
	return pow((1.0 - dot(normalize(normal), normalize(view))), amount) * color * intensity;
}

void vertex() {
	// Adjust vertex positions
	VERTEX.x += sin(TIME * flameTipFrequencyX) * flameTipAmplitudeX;
	VERTEX.z += sin(TIME * flameTipFrequencyZ) * flameTipAmplitudeZ;
}
