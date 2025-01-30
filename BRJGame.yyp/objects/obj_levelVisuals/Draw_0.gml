if(wiggle != 0) {
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, dsin(wiggleAdd + current_time / 9) * .75 * wiggle, c_white, 1);
} else {
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, 1);
}