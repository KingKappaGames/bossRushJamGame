if(room == rm_grassyArena) {
	if(gameState == "starting") {
		setGameState("respawn"); // intializing
	
		camera_set_view_size(view_camera[0], 480, 270);
		view_wport[0] = 1920;
		view_hport[0] = 1080;
	
		audio_stop_sound(snd_mainMenuSong);
		audio_play_sound(snd_bossGenericTheme, 10, true); 
	
		global.debrisSurface = surface_create(room_width, room_height);
		global.debrisBuffer = buffer_create(room_width * room_height * 4, buffer_fixed, 1);
		
		camWidth = camera_get_view_width(view_camera[0]);
		camHeight = camera_get_view_height(view_camera[0]);
	} else {
		//??
	}
} else if(room == rm_Main_Menu) {
	setGameState("starting");
}