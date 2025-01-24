if(!fakeOrb) {
	shader_set(shd_greyScale);
	shader_set_uniform_f((shader_get_uniform(shd_greyScale, "u_GrayscaleAmount")), 1);
	
	draw_sprite(sprite_index, image_index, x, y);
	shader_reset();
}

//draw_text_transformed(x, y - 25, connections, .5, .5, 0);