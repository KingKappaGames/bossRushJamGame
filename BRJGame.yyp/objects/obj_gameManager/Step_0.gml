if(keyboard_check_released(ord("F"))) { window_set_fullscreen(!window_get_fullscreen()); } // toggle fullscreen on "F" key released

if(!global.is_paused) {
	
	if(keyboard_check_released(vk_escape)) {
		global.is_paused = true;
		room_goto(rm_Main_Menu);
		exit; // break out of the non paused stuff when pausing initially
	}
	
	global.linksTotalThisFrame = [];
	
	var _drawnLinks = global.linksTotalThisFrame; // pairs of [orb1, orb2, linkDist]

	with(obj_orb) { // with each orb draw links but not duplicates
		if(linked) {
			for(var _connectionI = array_length(connections) - 1; _connectionI >= 0; _connectionI--) { // with each connected orb to that orb
				var _orb = connections[_connectionI][0];
				var _alreadyDrawn = false;
			
				if(instance_exists(_orb)) {
					for(var _totalLinksI = array_length(_drawnLinks) - 1; _totalLinksI >= 0; _totalLinksI--) { // check total connections to see if it's already been done
						var _pair = _drawnLinks[_totalLinksI];
						if(_pair[0] == _orb && _pair[1] == id) { // check if pair exists already, this is annoying to do like this but whatever (changed so that they don't check pairs going from them to others, because... You don't ever repeat the same connection within one orb unless the links are already broken beyond repair (they shouldn't be, if this wasn't clear) so don't bother checking if you already linked with x orb, it's not relevant
							_alreadyDrawn = true;
							break;
						}
					}
				
					if(!_alreadyDrawn) {
						var _dist = point_distance(x, y, _orb.x, _orb.y);
					
						array_push(_drawnLinks, [id, _orb, _dist]);
					}
				}
			}
		}
	}

	if(array_length(_drawnLinks) > 0) {
		global.boss.blockingLinksRef = _drawnLinks;
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
			setGameState("respawn");
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

	var _player = instance_nearest(room_width / 2, room_height / 2, obj_player);
	if(_player != noone) {
		var _camGoalX = ((_player.x * 5 + mouse_x) / 6) - camWidth / 2;
		var _camGoalY = ((_player.y * 5 + mouse_y) / 6) - camHeight / 2;

		if(_player != noone) {
			camera_set_view_pos(view_camera[0], clamp(lerp(camera_get_view_x(view_camera[0]), _camGoalX, .2) + irandom_range(-camShake, camShake), 0, room_width - camWidth), clamp(lerp(camera_get_view_y(view_camera[0]), _camGoalY, .2) + irandom_range(-camShake * .5, camShake * .5), 0, room_height - camHeight)); // loosely follow player and clamp without room bounds of camera
		}
	}
}


/*
show_debug_message("#");
show_debug_message(view_wport[0]);
show_debug_message(view_hport[0]);
show_debug_message(camera_get_view_width(view_camera[0]));
show_debug_message(camera_get_view_height(view_camera[0]));