shader_type canvas_item;

uniform int pixels_r = 16;
uniform int rays = 3;
uniform float inner = 0.1;
uniform float rot_per_second = 0.05;
uniform vec4 col: source_color = vec4(1.0);

const float R = 0.5;

float dist2(vec2 v) {
	return dot(v, v);
}

void fragment() {
	vec2 uv = round(UV * float(pixels_r * 2 + 1)) / float(pixels_r * 2 +1);
	if (dist2(uv - vec2(0.5)) > R*R) {
		discard;
	}
	
	vec2 centered = uv - vec2(0.5);
	float angle = (atan(centered.y, centered.x) + PI) / (2.0 * PI); // [0; 1]
	angle += mod(TIME * rot_per_second, 2.0 * PI);

	bool should_draw = dist2(uv - vec2(0.5)) <= inner * inner || int(round(angle * float(rays * 2))) % 2 == 0;
	if (! should_draw) discard;

	COLOR.a = 1.0-distance(uv * 2.0, vec2(1.0));
	
	COLOR *= col;
}

