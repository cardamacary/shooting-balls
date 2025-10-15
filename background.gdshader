shader_type canvas_item;

// Control params
uniform bool overlay = true;                         // true: draw stars over the texture; false: draw only stars
uniform float global_opacity : hint_range(0.0,1.0) = 1.0;
uniform vec2 stars_speed = vec2(0.05, 0.0);          // base speed (uv units per second)
uniform float stars_density : hint_range(0.0, 0.2) = 0.02;
uniform float star_base_size : hint_range(0.0005, 0.05) = 0.003; // radius in UV space

// deterministic pseudo-random
float rnd(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453123);
}

// soft circular point
float soft_star(vec2 p, float radius) {
	float d = length(p);
	// smooth edge for nicer antialiasing
	return smoothstep(radius, radius * 0.6, d);
}

void fragment() {
	// Normalized UV coordinates (0..1)
	vec2 uv = UV;

	// sample underlying texture (TextureRect must have a texture assigned, otherwise TEXTURE will be blank)
	vec3 base_col = texture(TEXTURE, UV).rgb;

	// accumulate stars from 3 layers with different speed/scale
	float star_acc = 0.0;

	// Layer A: small & fast
	{
		float scale = 900.0; // number of grid cells — higher = more granular
		vec2 offset_uv = fract((uv + TIME * stars_speed * 2.0) * scale);
		float r = rnd(floor(uv * scale)); // seed on cell index
		float mask = step(1.0 - stars_density * 0.7, r); // sparser or denser
		vec2 center = offset_uv - 0.5;
		float s = soft_star(center, star_base_size * 0.6);
		star_acc = max(star_acc, s * mask);
	}

	// Layer B: medium
	{
		float scale = 400.0;
		vec2 offset_uv = fract((uv + TIME * stars_speed * 1.0) * scale);
		float r = rnd(floor(uv * scale + 123.45));
		float mask = step(1.0 - stars_density, r);
		vec2 center = offset_uv - 0.5;
		float s = soft_star(center, star_base_size * 1.0);
		star_acc = max(star_acc, s * mask);
	}

	// Layer C: big & slow
	{
		float scale = 180.0;
		vec2 offset_uv = fract((uv + TIME * stars_speed * 0.35) * scale);
		float r = rnd(floor(uv * scale + 9876.54));
		float mask = step(1.0 - stars_density * 1.4, r);
		vec2 center = offset_uv - 0.5;
		float s = soft_star(center, star_base_size * 1.8);
		star_acc = max(star_acc, s * mask);
	}

	// final star color (white)
	vec3 star_col = vec3(star_acc);

	// compose
	vec3 final_col = overlay ? mix(base_col, base_col + star_col, star_acc * global_opacity) : (base_col * 0.0 + star_col * global_opacity);

	COLOR = vec4(final_col, 1.0);
}
