shader_type canvas_item;

uniform vec4 low: source_color;
uniform vec4 high: source_color;
uniform float interval;

vec4 halftone(vec2 pos, float value) {
	float lowv = length(low.rgb);
	float highv = length(high.rgb);
	value -= highv;
	value /= lowv - highv;
	vec2 center = round(pos / interval) * interval;
	float radius = length(center - pos) * 1.5 / interval;
	return radius < value ? low : high;
}

vec2 rotate(vec2 uv, vec2 pivot, float angle)
{
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle)),
						vec2(cos(angle), sin(angle)));
	
	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}

void fragment() {
	vec2 pos = SCREEN_UV / SCREEN_PIXEL_SIZE;
	pos = rotate(pos, vec2(0,0), 0.001 * TIME);
	pos += vec2(0.1, 0.2) * 100.0 * TIME;
	vec4 target = halftone(pos, length(COLOR.rgb));
	COLOR = vec4(target.rgb, min(COLOR.a, target.a));
}
