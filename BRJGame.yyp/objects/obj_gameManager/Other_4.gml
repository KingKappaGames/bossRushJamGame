if(room == rm_grassyArena) {
	setGameState("respawn"); // intializing
	
	camera_set_view_size(view_camera[0], 320, 180);
	view_wport[0] = 1920;
	view_hport[0] = 1080;
}

camWidth = camera_get_view_width(view_camera[0]);
camHeight = camera_get_view_height(view_camera[0]);