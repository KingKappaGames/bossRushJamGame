varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_GrayscaleAmount;

void main() {
	vec4 originalColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
  
	float luminance = dot(originalColor.rgb, vec3(0.299, 0.587, 0.114));
  
	vec4 grayscaleColor = vec4(luminance, luminance, luminance, originalColor.a);
 
	gl_FragColor = mix(originalColor, grayscaleColor, u_GrayscaleAmount);
}
