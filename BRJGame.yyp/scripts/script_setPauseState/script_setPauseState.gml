function script_setPauseState(pauseState, storeScreen = 0){
	if(pauseState == false) {
		global.is_paused = false;
		instance_activate_all();
		audio_resume_all();
		
		part_system_automatic_draw(global.partSys, true); //update every particle system with pause effect
		part_system_automatic_update(global.partSys, true); //update every particle system with pause effect
		part_system_automatic_draw(global.partUnderSys, true); //update every particle system with pause effect
		part_system_automatic_update(global.partUnderSys, true); //update every particle system with pause effect
	} else if(pauseState == true) {
		global.is_paused = true;
		if(storeScreen == 1) {
			if(surface_exists(pauseSurface)) {
				surface_copy_part(pauseSurface, 0, 0, application_surface, 0, 0, 1920, 1080);
				buffer_get_surface(pauseSurfaceBuffer, pauseSurface, 0);
			} else {
				pauseSurface = surface_create(1920, 1080);
				surface_copy_part(pauseSurface, 0, 0, application_surface, 0, 0, 1920, 1080);
				buffer_get_surface(pauseSurfaceBuffer, pauseSurface, 0);
			}
		}
		instance_deactivate_all(true);
		instance_activate_object(obj_PauseMenu);
		instance_activate_object(obj_DebugManager);
		instance_activate_object(obj_gameManager);

		audio_pause_all();
		audio_resume_sound(snd_spiderSongInitial); // don't pause songs
		
		part_system_automatic_draw(global.partSys, false); //update every particle system with pause effect
		part_system_automatic_update(global.partSys, false); //update every particle system with pause effect
		part_system_automatic_draw(global.partUnderSys, false); //update every particle system with pause effect
		part_system_automatic_update(global.partUnderSys, false); //update every particle system with pause effect
	}
}