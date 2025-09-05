shader_type canvas_item;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	float luminance = (color.r * 0.299 + color.g * 0.587 + color.b * 0.114);
	COLOR = vec4(vec3(luminance), color.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
