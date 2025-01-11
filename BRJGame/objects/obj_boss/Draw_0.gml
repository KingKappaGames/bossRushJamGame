draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * directionFacing, image_yscale, image_angle, make_color_rgb(255, 255 * (Health / HealthMax), 255 * (Health / HealthMax)), 1);

surface_set_target(script_getDebrisSurface());
gpu_set_blendmode_ext(bm_src_color, bm_dest_alpha); // why is gpu max just making everything black I don't udnerstand, unless it's adding to each channel ind giving a low max in each channel aka dark grey??
draw_set_alpha(.3);
draw_ellipse(x - 20 + irandom_range(-10, 10), y - 12 + irandom_range(-8, 8), x + 20 + irandom_range(-10, 10), y + 12 + irandom_range(-8, 8), false);
draw_set_alpha(1);
gpu_set_blendmode(bm_normal);
surface_reset_target();


if(blockingLinksRef != 0) {
	//draw_rectangle(200, 200, 500, 500, false);
}
//draw_set_color(make_color_rgb(255 * (1 - (Health / HealthMax)), 0, 0));
//draw_circle(x, y, 18, false);
//draw_set_color(c_white);