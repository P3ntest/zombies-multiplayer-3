shader_type canvas_item;

uniform vec3 gold_color = vec3(1.0, 0.843, 0.0);

void vertex() {
	// Called for every vertex the material is visible on
}

void fragment() {
	//vec3 gold_color = vec3(1.0, 0.843, 0.0);
	float brightness = COLOR.r * 0.299 + COLOR.g * 0.587 + COLOR.b * 0.114;

	brightness = 1.0 - brightness;

	brightness = floor(brightness * 5.0) / 5.0;

	float shiny_here = sin((UV.x * 2.0 + UV.y) * 10.0 + TIME * 3.0);
	shiny_here = clamp(shiny_here, 0.0, 1.0) * 0.2;
	brightness += shiny_here;
	brightness = clamp(brightness, 0.0, 1.0);


	// quantize brightness to create a banding effect

	float alpha = 0.0;
	if (COLOR.a > 0.0)
		alpha = 1.0;

	COLOR = vec4(gold_color * brightness, alpha);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
