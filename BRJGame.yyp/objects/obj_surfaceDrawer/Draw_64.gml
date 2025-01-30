if(room != rm_Main_Menu) {
	if(surfaceType == 1) {
		var _fogSurf = script_getFogSurface();
		
		draw_set_alpha(.55);
		draw_surface(_fogSurf, 0, 0); 
		draw_set_alpha(1);
		
		surface_set_target(_fogSurf);
		draw_clear_alpha(c_white, 0); // clear surface after each frame
		surface_reset_target();
	}
}