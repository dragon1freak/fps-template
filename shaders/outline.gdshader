shader_type canvas_item;
 
uniform vec4 outline_color : source_color = vec4(1.);
uniform lowp float outline_size : hint_range(0.0, 0.2, 0.001) = 0.01 ; // this is not in pixels.
uniform lowp float alpha_threshold : hint_range(0., 1., 0.1) = 0.5;
uniform float samples : hint_range(4, 32, 1) = 4;
 
vec2 rotate2d(vec2 vector, float angle){
	return vector * mat2(
				vec2(cos(angle),-sin(angle)),
                vec2(sin(angle),cos(angle)));
}

void fragment() {
	if (COLOR.a <= alpha_threshold) {
		

	
	vec2 AR = vec2(TEXTURE_PIXEL_SIZE.x/TEXTURE_PIXEL_SIZE.y, 1.);
	
	vec2 rightvec = vec2(outline_size, 0);
	float amax = 0.;

	for (float i = 0.; i<samples; i++) {
		vec2 samplevec = rotate2d(rightvec, i*TAU/float(samples))*AR;
		vec4 sample = texture(TEXTURE, UV+samplevec);
		amax = max(sample.a, amax);
	}
	
	if (amax == 0.0) discard;

	COLOR = mix(outline_color - vec4(0.,0.,0.,1.), outline_color, amax);
		};
}