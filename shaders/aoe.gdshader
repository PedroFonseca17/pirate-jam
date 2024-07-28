shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.0); // Control the expansion of the circle
uniform vec4 color : source_color; // Color of the circle

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;
    vec2 center = vec2(0.5, 0.5);
    float dist = length(uv - center);

    float alpha = smoothstep(radius - 0.1, radius, dist);
    vec4 col = mix(color, vec4(1.0, 0.0, 0.0, 1), alpha);

    COLOR = col;
}
