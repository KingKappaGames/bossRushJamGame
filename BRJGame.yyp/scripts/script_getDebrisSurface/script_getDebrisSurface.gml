function script_getDebrisSurface(){ // get the updated surface and replace it with the saved version if it get's lost in memory
	if(surface_exists(global.debrisSurface)) {
		return global.debrisSurface; // give existing surf, no problem
	} else {
		global.debrisSurface = surface_create(room_width * 1.5, room_height);
		buffer_set_surface(global.debrisBuffer, global.debrisSurface, 0); // got deleted, ergo replace it with saved version and return that
		
		return global.debrisSurface;
	}
}