event_inherited();

var _dirMoving = point_direction(0, 0, xChange, yChange);

headFacing = 1;
if(dirToPlayer > 90 && dirToPlayer < 270) {
	headFacing = -1;
}

if(xChange > 0) { // face in direction you're moving (depends on the sprite art direction..
	directionFacing = 1;
} else if(xChange < 0) {
	directionFacing = -1;
}

_dirMoving = point_direction(0, 0, xChange, yChange);
var _stuckMoveMultiplier = clamp(1 - global.bossStickingOrbs / 10, .1, 1);

if(stateType == "idle") {
	var _moveDir = point_direction(x, y, moveGoalX, moveGoalY);
	
	xChange += dcos(_moveDir) * moveSpeed  * _stuckMoveMultiplier;
	yChange += -dsin(_moveDir) * moveSpeed * _stuckMoveMultiplier; // with at speed but also move slower the more stuck you are in webs
	
	var _goalDist = point_distance(x, y, moveGoalX, moveGoalY);
	if(_goalDist < 40) {
		moveGoalX = irandom(room_width);
		moveGoalY = irandom(room_height);
	}
	
	if(player != noone) {
		var _playerDist = point_distance(x, y, player.x, player.y);
		 if(_playerDist < 80) {
			if(irandom(65) == 0) { // random chance to bite attack when very close (change as you see fit)
				setState("slashBasic", 60);
			}
		} else if(_playerDist < 200) {
			if(irandom(90) == 0) {
				setState("strafe", 90); // pursue the player for bite
			}
			
			if(shotsCooldown <= 0 && irandom(1300) == 0) {
				//random state with no conditions..?
				setState("chargeCast", 100);
			}
		} else if(_playerDist < 320) {
			if(shotsCooldown <= 0 && irandom(320) == 0) {
				setState("chargeCast", 100);
			} else if(irandom(300) == 0) {
				setState("strafe", 130); // pursue the player for bite
			}
		}
	}
	
	if(irandom(180 + point_distance(x, y, player.x, player.y) + global.bossStickingOrbs * 10) == 0) {
		x = irandom_range(room_width * .15, room_width * .85);
		y = irandom_range(room_height * .15, room_height * .85);
		setState("teleport", 15);
	}
} else if(stateType == "attack") {
	if(state == "slashBasic") {
		
		if(stateTimer / stateTimerMax > .75) {
			partJumpAngle = dirToPlayer;
		} else if(stateTimer / stateTimerMax > .18) {
			var _progress = 0;
			repeat(36) {
				part_particles_create_color(partSys, partSwingX + dcos(partSwingDir) * _progress + random_range(-7, 7), partSwingY - dsin(partSwingDir) * _progress + random_range(-7, 7), swordTrail, #bfffcf, 1); // clone color #bbffe0
				_progress += 1.55;
			}
			if(stateTimer / stateTimerMax < .45) {
				if(extraMoveUsed == false) {
					xChange = dcos(partJumpAngle) * 5.2 + global.gameDifficultySelected; // 5.2 - 7.2
					yChange = -dsin(partJumpAngle) * 5.2 + global.gameDifficultySelected;
					audio_play_sound(choose(snd_mantisSwing, snd_mantisSwing2), 0, 0, 1);
					extraMoveUsed = true; // in this case extra move is speed, not a good way to do this but I don't care
				}
				
				partSwingDir += 18.5;
				partSwingX = lerp(partSwingX, x + dcos(partJumpAngle + 30) * 42, .3);
				partSwingY = lerp(partSwingY, y - dsin(partJumpAngle + 30) * 42, .3);
			}
		}
	}
	
	script_doHitboxCollisionsAndDamage();
	
	if(stateTimer <= 0) {
		setState("idle");
	}
} else if(stateType == "charge") {
	if(state == "chargeCast") {
		if(stateTimer <= 0) {
			
			setState("cast", 180);
		}
	}
} else if(stateType == "move") {
	 if(state == "chase") {
		 var _speedMultFromDifficulty = array_get([.8, .99, 1.05], global.gameDifficultySelected); // get speeds from difficulty selection, that being said, the speed is very close to being too much so 1.03 is harder than 1 while .85 is quite easy
		 
		xChange += dcos(dirToPlayer) * moveSpeed * 1 * _stuckMoveMultiplier * _speedMultFromDifficulty;
		yChange -= dsin(dirToPlayer) * moveSpeed * 1 * _stuckMoveMultiplier * _speedMultFromDifficulty;
		
		if(point_distance(x, y, player.x, player.y) < 75) {
			setState("slashBasic", 50);
		}
		
		if(stateTimer <= 0) {
			setState("strafe");
		}
	} else if(state == "strafe") {
		if(irandom(300) == 0) {
			strafeDir = choose(-1, 1);
		}
		
		if(irandom(360 - global.gameDifficultySelected) == 0) {
			spawnClone(0, 0, true); // spawn ghost clones (1)
		}
		
		
		var _distToPlayer = point_distance(x, y, player.x, player.y);
		
		if(_distToPlayer < 65) {
			if(irandom(110) == 0) {
				setState("chase", 100);
			}
			
			xChange += dcos(dirToPlayer + 162 * strafeDir) * moveSpeed * .26 * _stuckMoveMultiplier;
			yChange -= dsin(dirToPlayer + 162 * strafeDir) * moveSpeed * .26 * _stuckMoveMultiplier;
		} else if(_distToPlayer < 90) {
			if(irandom(210) == 0) {
				setState("chase", 170);
			}
			
			xChange += dcos(dirToPlayer + 150 * strafeDir) * moveSpeed * .13 * _stuckMoveMultiplier;
			yChange -= dsin(dirToPlayer + 150 * strafeDir) * moveSpeed * .13 * _stuckMoveMultiplier;
		} else if(_distToPlayer < 170) {
			if(irandom(260) == 0) {
				setState("chase", 200);
			} else if(irandom(800) == 0) {
				setState("chargeCast", 110);
			}
			
			xChange += dcos(dirToPlayer + 30 * strafeDir) * moveSpeed * .23 * _stuckMoveMultiplier;
			yChange -= dsin(dirToPlayer + 30 * strafeDir) * moveSpeed * .23 * _stuckMoveMultiplier;
		} else if(_distToPlayer > 250) {
			if(irandom(180) == 0) {
				setState("idle");
			} else if(irandom(390) == 0) {
				setState("chargeCast", 130);
			}
		} else { // 170 - 250 ?
			xChange += dcos(dirToPlayer + 15 * strafeDir) * moveSpeed * .38 * _stuckMoveMultiplier;
			yChange -= dsin(dirToPlayer + 15 * strafeDir) * moveSpeed * .38 * _stuckMoveMultiplier;
			
			if(irandom(750) == 0) {
				setState("chargeCast", 120);
			} else if(irandom(600 + global.bossStickingOrbs * 10) == 0) {
				var _dir = irandom(360);
				x = player.x + dcos(_dir) * 50;
				y = player.y - dsin(_dir) * 50;
				setState("teleport");
			}
		}
	}
} else if(stateType == "cast") {
	
	y += dsin(current_time * 1.5) * 1.2;
	
	if(state == "cast") {
		frontArmSwingAngle += 5 + global.gameDifficultySelected;
		if(frontArmSwingAngle > 90) {
			frontArmSwingAngle = 5 + irandom_range(-10, 10);
			script_createBullet(3, x + 10 * directionFacing, y - 8, dirToPlayer + irandom_range(-20, 20), 4, true, obj_slashWave, 360 + global.gameDifficultySelected * 90);
		}
		
		
		backArmSwingAngle += 4 + global.gameDifficultySelected;
		if(backArmSwingAngle > 90) {
			backArmSwingAngle = 5 + irandom_range(-10, 10);
			script_createBullet(3, x + 10 * directionFacing, y - 8, dirToPlayer + irandom_range(-20, 20), 4, true, obj_slashWave, 360 + global.gameDifficultySelected * 90);
		}
	}
	
	if(stateTimer <= 0) {
		setState("strafe");
	}
} else if(stateType == "intro") {
	 if(state == "intro") {
		//?
		var _camWidth = camera_get_view_width(view_camera[0]);
		var _camHeight = camera_get_view_height(view_camera[0]);
		if(stateTimer < .15) {
			if(!audio_is_playing(snd_mantisRoar)) {
				audio_play_sound(snd_mantisRoar, 0, 0, 1);
			}
		}
		
		if(stateTimer <= stateTimerMax * .25) { // teleport into view
			if(!audio_is_playing(snd_mantisSongInitial)) {
				audio_stop_sound(global.musicActualPlaying);
				global.musicPlaying = snd_mantisSongInitial;
				global.musicActualPlaying = audio_play_sound(global.musicPlaying, 100, 0);
			}
			
			camera_set_view_pos(view_camera[0], lerp(camera_get_view_x(view_camera[0]), room_width * .5 - _camWidth / 2, .07), clamp(lerp(camera_get_view_y(view_camera[0]), room_height * .25 - _camHeight / 2, .07), 0, room_height - _camHeight)); // switch camera around level to simulate looking around
			if(!instance_exists(obj_LightBeamEffect)) {
				x = room_width / 2;
				y = room_height * .25;
				
				var _beam = instance_create_layer(x, y, "Instances", obj_LightBeamEffect);
				_beam.augmentEffect(50, 2.3, c_white, .8);
			}
		} else if(stateTimer <= stateTimerMax * .4) {
			camera_set_view_pos(view_camera[0], lerp(camera_get_view_x(view_camera[0]), room_width * .22 - _camWidth / 2, .07), clamp(lerp(camera_get_view_y(view_camera[0]), room_height * .33 - _camHeight / 2, .07), 0, room_height - _camHeight)); // switch camera around level to simulate looking around
		} else if(stateTimer <= stateTimerMax * .6) {
			camera_set_view_pos(view_camera[0], lerp(camera_get_view_x(view_camera[0]), room_width * .84 - _camWidth / 2, .07), clamp(lerp(camera_get_view_y(view_camera[0]), room_height * .44 - _camHeight / 2, .07), 0, room_height - _camHeight)); // switch camera around level to simulate looking around
		} else if(stateTimer <= stateTimerMax * .8) {
			camera_set_view_pos(view_camera[0], lerp(camera_get_view_x(view_camera[0]), room_width * .34 - _camWidth / 2, .07), clamp(lerp(camera_get_view_y(view_camera[0]), room_height * .2 - _camHeight / 2, .07), 0, room_height - _camHeight)); // switch camera around level to simulate looking around
		} else if(stateTimer <= stateTimerMax) { // first step
			camera_set_view_pos(view_camera[0], lerp(camera_get_view_x(view_camera[0]), room_width * .75 - _camWidth / 2, .07), clamp(lerp(camera_get_view_y(view_camera[0]), room_height * .1 - _camHeight / 2, .07), 0, room_height - _camHeight)); // switch camera around level to simulate looking around
		}
		
		if(stateTimer <= 0) {
			//teleport away
			
			x = choose(200, 450);
			y = room_height * .73;
			
			setState("teleport", 15);
		}
	}
} else if(stateType == "dead") {
	 if(state == "dead") {
		var _camWidth = camera_get_view_width(view_camera[0]);
		var _camHeight = camera_get_view_height(view_camera[0]);
		
		if(stateTimer > stateTimerMax * .85) {
			deathCamX = x;
			deathCamY = y;
		} else if(stateTimer > stateTimerMax * .325) {
			if(stateTimer % 25 == 0) {
				deathCamX = irandom_range(room_width * .15, room_width * .85);
				deathCamY = irandom_range(room_height * .15, room_height * .85);
				x = deathCamX;
				y = deathCamY;
				
				var _beam = instance_create_layer(x, y, "Instances", obj_LightBeamEffect);
				_beam.augmentEffect(38 + irandom(8), 5, c_white, .8);
				
				#region pull legs in
				var _legPos = 0;
				var _legPosGoal = 0;
				var _legOrigin = 0;
				var _legAngle =  90 - (directionFacing * 90) + 40;
	
				for(var _legI = 0; _legI < 4; _legI++) {					
					_legPos = legPositions[_legI];
					_legPosGoal = legPositionGoals[_legI];
					_legOrigin = legOrigins[_legI];
	
					_legOrigin[0] = x - 11 * directionFacing + dcos(_legAngle) * 8;
					_legOrigin[1] = y + 2 - dsin(_legAngle) * 5;
	
					var _goalX = _legOrigin[0] + dcos(_legAngle) * legStepDist;
					var _goalY = _legOrigin[1] - dsin(_legAngle) * legStepDist;
		
					_legPosGoal[0] = _goalX;
					_legPosGoal[1] = _goalY; // set the next step point to the goal positions
					_legPos[0] = _goalX;
					_legPos[1] = _goalY;
	
					_legAngle += 100;
					if(_legI == 1) {
						_legAngle -= 20;
					}
				}
				#endregion
			}
		} else if(deathIntact) { // final section
			if(stateTimer < stateTimerMax * .175) {
				audio_play_sound(snd_mantisExplode, 1, 0);
				part_type_color_mix(global.projectileTrail, #ccff44, #66ff67); 
				repeat(60) {
					part_particles_create_color(partSys, x + 8 * directionFacing + irandom_range(-15, 15), y - 8 + irandom_range(-15, 15), cloneBurstParts, #88ff88, 1);
					part_particles_create_color(partSys, x + 8 * directionFacing + irandom_range(-15, 15), y - 8 + irandom_range(-15, 15), fluffParticle, #88ff88, 1);
				} 
			
				for(var _i = sprite_get_number(spr_mantisDebrisPieces) - 1; _i >= 0; _i--) {
					var _piece = instance_create_depth(x, y, -y, obj_debrisObjects);
					_piece.sprite_index = spr_mantisDebrisPieces;
					_piece.image_index = _i;
				}
				//spawn pieces!
				
			
				deathIntact = false;
			}
		}
		camera_set_view_pos(view_camera[0], lerp(camera_get_view_x(view_camera[0]), deathCamX - _camWidth / 2, .09), clamp(lerp(camera_get_view_y(view_camera[0]), deathCamY - _camHeight / 2, .07), 0, room_height - _camHeight)); // switch camera around level to simulate looking around
		
		if(stateTimer <= 0) {
			global.gameManager.setGameState("victory");
			instance_destroy();
		}
	}
} else if(stateType == "teleport") {
	// when this boss teleports all the links that become overstretched will be broken by default
	
	if(stateTimer <= 0) {
		if(irandom(3) == 0) {
			setState("teleport", 15);
		} else {
			if(point_distance(x, y, player.x, player.y) < 60) {
				setState("chase", 40);
			} else {
				setState("idle");
			}
		}
	}
}

if(shotsCooldown > 0) {
	shotsCooldown--;
}

#region leg stuff
if(state != "dead" && state != "cast") {
	var _legPos = 0;
	var _legPosGoal = 0;
	var _legOrigin = 0;
	var _legAngle =  90 - (directionFacing * 90) + 40;
	for(var _legI = 0; _legI < 4; _legI++) {
		_legPos = legPositions[_legI];
		_legPosGoal = legPositionGoals[_legI];
		_legOrigin = legOrigins[_legI];
	
		_legOrigin[0] = x - 11 * directionFacing + dcos(_legAngle) * 8;
		_legOrigin[1] = y + 2 - dsin(_legAngle) * 5;
	
		var _goalX = _legOrigin[0] + dcos(_legAngle + random_range(-4, 4)) * legStepDist * random_range(.9, 1.18) + (x - xprevious) * 17; // maybe clamp the prediction values
		var _goalY = _legOrigin[1] - dsin(_legAngle + random_range(-4, 4)) * legStepDist * random_range(.9, 1.18) + (y - yprevious) * 13; // move feet to neutral positions pushed ahead 20x the position change for step pathing improvement
	
		var _legStepDist = point_distance(_goalX, _goalY, _legPos[0], _legPos[1]);
		if(_legStepDist > legUpdateDistance || irandom(180) == 0) {
			legStepDistances[_legI] = point_distance(_legPos[0], _legPos[1], _goalX, _goalY);
			_legPosGoal[0] = _goalX;
			_legPosGoal[1] = _goalY; // set the next step point to the goal positions
		}
	
		// moving the legs to the goals
		_legPos[0] = lerp(_legPos[0], _legPosGoal[0], .26);
		_legPos[1] = lerp(_legPos[1], _legPosGoal[1], .26);
	
		_legAngle += 100;
		if(_legI == 1) {
			_legAngle -= 20;
		}
	}
} else {
	for(var _i = 0; _i < 4; _i++) {
		legPositions[_i][0] = lerp(legPositions[_i][0], legPositionGoals[_i][0], .04);
		legPositions[_i][1] = lerp(legPositions[_i][1], legPositionGoals[_i][1], .04);
	}
}
#endregion