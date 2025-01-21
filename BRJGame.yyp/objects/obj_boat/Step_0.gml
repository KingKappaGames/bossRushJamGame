if(instance_exists(global.player)) {
	if(active) {		
		if(y > room_height + 50) {
			transitionTime++;
			if(transitionTime > transitionTimeMax) {
				//room_goto(rm_fields);
				y = -40;
				x += 30;
				
				global.player.x = x;
				global.player.y = y;
			}
			// start transition and switch to top of next room
		} else {
			if(transitionTime > 0) {
				transitionTime--;
			}
			
			x += .15;
			y += .6;
	
			global.player.x = lerp(global.player.x, x, .05);
			global.player.y = lerp(global.player.y, y, .05);
		
			camera_set_view_pos(view_camera[0], x - camera_get_view_width(view_camera[0]) / 2, clamp(y - camera_get_view_height(view_camera[0]) / 2, 0, room_height - camera_get_view_height(view_camera[0])));
		}
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