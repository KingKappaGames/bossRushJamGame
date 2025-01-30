if(object_index == obj_bullet) {
	draw_sprite_ext(sprite_index, image_index, x, y - flightHeight * 2, image_xscale, image_yscale, image_angle, c_white, 1);
	if(drawNextFrame) {
		surface_set_target(script_getDebrisSurface());
		draw_sprite_ext(sprite_index, image_index, x + room_width * .25, y - flightHeight * 2, image_xscale, image_yscale, image_angle, c_white, 1);
		surface_reset_target();
		
		instance_destroy();
	}
}