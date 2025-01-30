surface_set_target(script_getFogSurface());
draw_sprite_ext(sprite_index, image_index, (x - camera_get_view_x(view_camera[0])) * 4, (y - camera_get_view_y(view_camera[0])) * 4, image_xscale * 4 * xflip, image_yscale * 4 * yflip, image_angle, image_blend, image_alpha);
surface_reset_target();