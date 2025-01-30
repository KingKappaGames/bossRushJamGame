function script_getFogSurface() {
	if(surface_exists(global.fogSurface)) {
		return global.fogSurface; // give existing surf, no problem
	} else {
		global.fogSurface = surface_create(1920, 1080);
		
		return global.fogSurface;
	}
}