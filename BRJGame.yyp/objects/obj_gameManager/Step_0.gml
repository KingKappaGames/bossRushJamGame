if(keyboard_check_released(ord("F"))) { window_set_fullscreen(!window_get_fullscreen()); } // toggle fullscreen on "F" key released

if(!global.is_paused) {
	menu_close = false;
	if(keyboard_check_released(vk_escape) && room != rm_Main_Menu) {
		
		//instance_deactivate_all(true);
		instance_create_layer(room_width / 2, room_width / 2, "Instances", obj_PauseMenu);
		
		exit; // break out of the non paused stuff when pausing initially
	}

	if(gameState == "gameOver") {
		gameStateTimer--;
		if(gameStateTimer <= 0) {
			setGameState("respawn");
		}
	} else if(gameState == "respawn") {
		if(mouse_check_button_released(mb_left) || mouse_check_button_released(mb_right)) {
			setGameState("prefight");
			instance_destroy(obj_player);
			instance_destroy(obj_bossBase);
			instance_destroy(obj_orbParent);
			instance_destroy(obj_bullet);
			instance_destroy(obj_attackWebNode);
		
			instance_create_layer(-300, room_height / 2, "Instances", obj_player);
			camera_set_view_pos(view_camera[0], -300 - camWidth / 2, room_height / 2 - camHeight / 2);
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
	} else if(gameState == "prefight") {
		if(instance_exists(global.player)) {
			if(global.player.x > room_width / 3) {
				//start cutscene and then boss "fight" state
				setGameState("intro", 320);
			}
		}
		
		if(global.musicPlaying != -1) {
			if(global.musicActualPlaying != -1) {
				audio_sound_gain(global.musicActualPlaying, 0, 3000);
				global.musicPlaying = -1;
			}
		}
		
		if(!audio_is_playing(snd_treeWind)) {
			audio_play_sound(snd_treeWind, 0, 0, random_range(.8, 1.2), 0, random_range(.95, 1.05));
		}
	} else if(gameState == "intro") {
		gameStateTimer--;
		if(gameStateTimer <= 0) {
			setGameState("fight");
		}
	}
	
	if(irandom(60) == 0) {
		instance_create_layer(0, -100, "Instances", obj_fogVisual);
	}

	//if(gameState == "fight") {
		//var _linksTotal = global.linksTotalThisFrame;
	
	
	//}


	camShake *= .98;
	
	if(gameState != "sail") {
		if(gameState != "intro") {
			var _player = instance_nearest(room_width / 2, room_height / 2, obj_player);
			if(instance_exists(_player)) {
				var _camGoalX = ((_player.x * 3 + mouse_x) / 4) - camWidth / 2;
				var _camGoalY = ((_player.y * 3 + mouse_y) / 4) - camHeight / 2;

				if(_player.x > room_width || _player.x < 0) {
					if(_player.x > room_width) {
						if(!audio_is_playing(global.musicActualPlaying)) {
							global.musicPlaying = snd_riverSongInitial;
							global.musicActualPlaying = audio_play_sound(global.musicPlaying, 100, 0);
						}
					}
					
					_camGoalY = room_height / 2 - camHeight / 2 - 10; // set to middle of room if along extra area to water
					camera_set_view_pos(view_camera[0], clamp(lerp(camera_get_view_x(view_camera[0]), _camGoalX, .04) + irandom_range(-camShake, camShake), -room_width, room_width * 2 - camWidth), clamp(lerp(camera_get_view_y(view_camera[0]), _camGoalY, .08) + irandom_range(-camShake * .5, camShake * .5), 0, room_height - camHeight));
				} else { // in main fight area
					_camGoalX = clamp(_camGoalX, 0, room_width - camWidth); // clamp horizontal to battle area (well, don't clamp but clamp the goal so that it quickly follows the left and right limits, it's not an issue if a player sneaks a little peak..)
					camera_set_view_pos(view_camera[0], clamp(lerp(camera_get_view_x(view_camera[0]), _camGoalX, .06) + irandom_range(-camShake, camShake), -room_width, room_width * 2 - camWidth), clamp(lerp(camera_get_view_y(view_camera[0]), _camGoalY, .06) + irandom_range(-camShake * .5, camShake * .5), 0, room_height - camHeight));
				}
			}
		} else {
			var _boss = instance_find(obj_bossBase, 0);
			
			if(_boss.object_index != obj_bossMantis) { // mantis does it's own control
				var _camGoalX = _boss.x - camWidth / 2;
				var _camGoalY = _boss.y - camHeight / 2 + 60;
				var _camShake = array_get([0, .7, 1, 1.25, 1.8], global.gameScreenShakeSelected) * camShake;
				camera_set_view_pos(view_camera[0], clamp(lerp(camera_get_view_x(view_camera[0]), _camGoalX, .05) + irandom_range(-_camShake, _camShake), -room_width, room_width * 2 - camWidth), clamp(lerp(camera_get_view_y(view_camera[0]), _camGoalY, .05) + irandom_range(-_camShake * .5, _camShake * .5), 0, room_height - camHeight)); // follow boss during intro, roughly
			}
		}
	}
}

if(global.musicActualPlaying != -1) {
	if(audio_sound_get_gain(global.musicActualPlaying) <= .06) {
		audio_stop_sound(global.musicActualPlaying);
		global.musicActualPlaying = -1;
	}
}

var _song = global.musicPlaying;
if(_song != -1) {
	if(!audio_is_playing(_song)) { // if no menu music start the first and start the second from then on
		if(_song == snd_rollerSongInitial) {
			global.musicPlaying = snd_rollerSongLoop;
		} else if(_song == snd_spiderSongInitial) {
			global.musicPlaying = snd_spiderSongLoop;
		} else if(_song == snd_mantisSongInitial) {
			global.musicPlaying = snd_mantisSongLoop;
		} else if(_song == snd_riverSongInitial) {
			global.musicPlaying = snd_riverSongLoop;
		}
	
		global.musicActualPlaying = audio_play_sound(global.musicPlaying, 10, true);
	}
}

if(room == rm_credits) {
	if(keyboard_check_released(vk_escape) || keyboard_check_released(vk_space) || keyboard_check_released(ord("E")) || mouse_check_button_released(mb_left)) {
		keyboard_clear(vk_escape);
		keyboard_clear(vk_space);
		keyboard_clear(ord("E"));
		mouse_clear(mb_left);
		room_goto(rm_Main_Menu);
	}
}