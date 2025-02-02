shader_set(shd_frozenHue);
shader_set_uniform_f((shader_get_uniform(shd_frozenHue, "u_GrayscaleAmount")), clamp((1 - frozenSpeedMult) * 2, 0, 1));

draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * directionFacing, image_yscale, image_angle, make_color_rgb(255, 255 * (Health / HealthMax), 255 * (Health / HealthMax)), 1);

shader_reset();

//if(blockingLinksRef != 0) {
	//draw_rectangle(200, 200, 500, 500, false);
//}
//draw_set_color(make_color_rgb(255 * (1 - (Health / HealthMax)), 0, 0));
//draw_circle(x, y, 18, false);
//draw_set_color(c_white);