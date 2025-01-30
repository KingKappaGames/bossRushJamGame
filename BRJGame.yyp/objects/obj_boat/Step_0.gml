if(instance_exists(global.player)) {
	if(active > 0) {	
		active--;
		if(active <= 0) {
			active = 0;
			global.player.setState("idle");
			global.gameManager.setGameState("prefight");
			
			interactionRange = 0; // cancel the boat..
		}
		
		if(y > room_height + 80) {
			transitionTime++;
			if(transitionTime > transitionTimeMax) {
				room_goto(rm_grassyArena);
				path_start(path_riverRaftingEntry, .9, path_action_stop, true);
				y = -118;
				x = -838;
				
				global.player.x = x;
				global.player.y = y;
				var _feetPos = global.player.legPositions;
				for(var _i = 0; _i < 8; _i++) {
					_feetPos[_i][0] += x - xprevious;
					_feetPos[_i][1] += y - yprevious;
				}
			}
			// start transition and switch to top of next room
		} else {
			if(transitionTime > 0) {
				transitionTime--;
			}
	
			global.player.x = lerp(global.player.x, x, .05);
			global.player.y = lerp(global.player.y, y, .05);
			var _feetPos = global.player.legPositionGoals;
			for(var _i = 0; _i < 8; _i++) {
				_feetPos[_i][0] += x - prevX;
				_feetPos[_i][1] += y - prevY;
			}
			
			camera_set_view_pos(view_camera[0], x - camera_get_view_width(view_camera[0]) / 2, clamp(y - camera_get_view_height(view_camera[0]) / 2, 0, room_height - camera_get_view_height(view_camera[0])));
		}
		
		prevX = x;
		prevY = y;
	} else {
		inRange = false;
		if(point_distance(x, y, global.player.x, global.player.y) < interactionRange) {
			inRange = true;
			if(mouse_check_button_released(mb_left)) {
				activate();
			}
		}
	}
}