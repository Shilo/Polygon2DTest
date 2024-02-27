shader_type canvas_item;
uniform int amount_of_colors;
uniform vec4[12] colors:source_color;

void fragment() {
    vec2 offset =(UV - vec2(0.5, 0.5)) * 2.0;
    float angle = PI + atan(offset.y, offset.x);
    int index = int(floor(angle/TAU * float(amount_of_colors)));
    COLOR = colors[index];
    COLOR.a = step(distance(UV, vec2(0.5, 0.5)), 0.5);
}