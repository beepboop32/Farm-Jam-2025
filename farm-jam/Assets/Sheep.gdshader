shader_type canvas_item;

uniform float outline_width = 1.0;
uniform vec4 outline_color : source_color;
uniform vec4 texture_region = vec4(0.0);

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec2 outline_offset = vec2(outline_width) * TEXTURE_PIXEL_SIZE;
	vec4 uv_region = vec4(texture_region.xy * TEXTURE_PIXEL_SIZE, texture_region.zw * TEXTURE_PIXEL_SIZE);
	if (uv_region.zw == vec2(0.0)) {
		uv_region.zw = vec2(1.0);
	}

	float uv_offset;
	float a;
	float max_a = 0.0;

	uv_offset = UV.y - outline_offset.y;
	if (uv_offset > uv_region.y) {
		a = texture(TEXTURE, vec2(UV.x, uv_offset)).a;
		max_a = max(a, max_a);
	}

	uv_offset = UV.y + outline_offset.y;
	if (uv_offset < uv_region.y + uv_region.w) {
		a = texture(TEXTURE, vec2(UV.x, uv_offset)).a;
		max_a = max(a, max_a);
	}

	uv_offset = UV.x - outline_offset.x;
	if (uv_offset > uv_region.x) {
		a = texture(TEXTURE, vec2(uv_offset, UV.y)).a;
		max_a = max(a, max_a);
	}

	uv_offset = UV.x + outline_offset.x;
	if (uv_offset < uv_region.x + uv_region.z) {
		a = texture(TEXTURE, vec2(uv_offset, UV.y)).a;
		max_a = max(a, max_a);
	}

	COLOR = mix(color, outline_color, max_a - color.a);
}

uniform float interval = 0.5; // the displacement will happen every [interval] seconds
uniform float timeDelay = 0.0; // use it if you don't want all the sprites to move at the same time
uniform float intensityX = 20.0; // X axis force of movement
uniform float intensityY = 20.0; // Y axis force of movement
uniform float seed = 42.0; // seed to randomize movement
vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123));
}

void vertex() {
	float chunk = floor((TIME + timeDelay) / interval);
	float seedNum = VERTEX.x + VERTEX.y + chunk + seed;
	float offsetX = sin(seedNum * 12.9898) * 43758.5453;
	float offsetY = sin(seedNum * 32.9472) * 94726.0482;
	offsetX = fract(offsetX);
	offsetX = offsetX * 2.0 - 1.0;
	offsetY = fract(offsetY);
	offsetY = offsetY * 2.0 - 1.0;
	VERTEX += vec2(offsetX * intensityX, offsetY * intensityY);
}