if(keyboard_check_released(ord("F"))) { window_set_fullscreen(!window_get_fullscreen()); } // toggle fullscreen on "F" key released

if(!global.is_paused) {
	menu_close = false;
	if(keyboard_check_released(vk_escape) && room != rm_Main_Menu) {
		
		global.is_paused = true;
		//room_goto(rm_Main_Menu);
		instance_deactivate_all(true);
		instance_activate_object(obj_Menu_Manager);
		instance_activate_object(obj_DebugManager);
		
		obj_Menu_Manager.clearButtons();
		obj_Menu_Manager.menu_up = true;
		
		exit; // break out of the non paused stuff when pausing initially
	}

	if(gameState == "gameOver") {
		gameStateTimer--;
		if(gameStateTimer <= 0) {
			setGameState("respawn");
		}
	} else if(gameState == "respawn") {
		if(mouse_check_button_released(mb_left) || mouse_check_button_released(mb_right)) {
			setGameState("fight");
		}
	} else if(gameState == "victory") {
		gameStateTimer--;
		if(gameStateTimer <= 0) {
			setGameState("moveZone");
		}
	} else if(gameState == "fight") {
		debrisSaveTimer--;
		if(debrisSaveTimer <= 0) {
			buffer_get_surface(global.debrisBuffer, script_getDebrisSurface(), 0);
		
			debrisSaveTimer = 600;
		}
	}

	//if(gameState == "fight") {
		//var _linksTotal = global.linksTotalThisFrame;
	
	
	//}


	camShake *= .98;

	if(gameState != "sail") {
		var _player = instance_nearest(room_width / 2, room_height / 2, obj_player);
		if(instance_exists(_player)) {
			var _camGoalX = ((_player.x * 3 + mouse_x) / 4) - camWidth / 2;
			var _camGoalY = ((_player.y * 3 + mouse_y) / 4) - camHeight / 2;

			if(_player.x > room_width || _player.x < 0) {
				_camGoalY = room_height / 2 - camHeight / 2 - 10; // set to middle of room if along extra area to water
			}
		
			camera_set_view_pos(view_camera[0], clamp(lerp(camera_get_view_x(view_camera[0]), _camGoalX, .05) + irandom_range(-camShake, camShake), -room_width, room_width * 2 - camWidth), clamp(lerp(camera_get_view_y(view_camera[0]), _camGoalY, .05) + irandom_range(-camShake * .5, camShake * .5), 0, room_height - camHeight)); // loosely follow player and clamp without room bounds of camera
		}
	}
}
else
{
	if(keyboard_check_released(vk_escape) || menu_close)
	{
		global.is_paused = false;
		//instance_activate_all();
		alarm_set(1, 5);
		
		obj_Menu_Manager.menu_up = false;
	};
};

fmod_studio_system_update();

/*
show_debug_message("#");
show_debug_message(view_wport[0]);
show_debug_message(view_hport[0]);
show_debug_message(camera_get_view_width(view_camera[0]));
show_debug_message(camera_get_view_height(view_camera[0]));