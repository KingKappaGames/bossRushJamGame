if(surface_exists(pauseSurface)) {
	shader_set(shd_blur);
	shader_set_uniform_f_array(shader_get_uniform(shd_blur, "size"), [1920, 1080, 14]); 
	draw_surface_ext(pauseSurface, camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]), .25, .25, 0, c_white, 1);
	shader_reset();
} else {
	pauseSurface = surface_create(1920, 1080);
	buffer_set_surface(pauseSurfaceBuffer, pauseSurface, 0);
}

if(optionGroup == 5) { // custom draw groups
	draw_sprite(spr_controlDiagram, 0, x, y);
} else if(optionGroup == 2) {
	draw_sprite_ext(spr_optionMeter, gameEffectVolume, camera_get_view_x(view_camera[0]) + 223, camera_get_view_y(view_camera[0]) + 44, 2.5 * (320 / 1366), 2.5 * (180 / 768), 0, c_white, 1);
	draw_sprite_ext(spr_optionMeter, gameMusicVolume, camera_get_view_x(view_camera[0]) + 223, camera_get_view_y(view_camera[0]) + 70, 2.5 * (320 / 1366), 2.5 * (180 / 768), 0, c_white, 1);
} else if(optionGroup == 3) {
	
} else if(optionGroup == 5) {
	
}