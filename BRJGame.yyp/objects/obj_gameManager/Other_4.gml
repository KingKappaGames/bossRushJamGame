if(room == rm_grassyArena) {
	if(gameState == "starting") {
		instance_create_layer(-640, 0, "Instances", obj_creditsFloorText);
		instance_create_layer(-580, room_height * .37, "Instances", obj_speaker);
		
		setGameState("prefight"); // intializing
	
		camera_set_view_size(view_camera[0], 480, 270);
		view_wport[0] = 1920;
		view_hport[0] = 1080; 
	
		global.debrisSurface = surface_create(room_width * 1.5, room_height);
		global.debrisBuffer = buffer_create(room_width * room_height * 6, buffer_fixed, 1); // 1.5 width and height
		
		camWidth = camera_get_view_width(view_camera[0]);
		camHeight = camera_get_view_height(view_camera[0]);
		
		instance_create_layer(-300, room_height / 2, "Instances", obj_player);
		camera_set_view_pos(view_camera[0], -300 - camWidth / 2, room_height / 2 - camHeight / 2);
	} else {
		//??
		global.debrisSurface = surface_create(room_width * 1.5, room_height);
		buffer_get_surface(global.debrisBuffer, global.debrisSurface, 0);
	}
	
	instance_create_layer(x, y, "Instances", obj_surfaceDrawer);
	
	var _fogSurface = instance_create_layer(x, y, "Instances", obj_surfaceDrawer);
	_fogSurface.surfaceType = 1;
	_fogSurface.depth = -1001;
} else if(room == rm_Main_Menu) {
	instance_create_layer(x, y, "Instances", obj_MainMenu);
	setGameState("starting");
}