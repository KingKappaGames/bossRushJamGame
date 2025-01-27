event_inherited();

var _dirMoving = point_direction(0, 0, xChange, yChange);
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
	
	image_angle += _stuckMoveMultiplier * angle_difference(point_direction(0, 0, xChange, yChange), image_angle) / 10;

	if(player != noone) {
		var _playerDist = point_distance(x, y, player.x, player.y);
		 if(_playerDist < 40) {
			if(irandom(75) == 0) { // random chance to bite attack when very close (change as you see fit)
				setState("bite", 60);
			}
		} else if(_playerDist < 200) {
			if(irandom(110) == 0) {
				setState("strafe", 90); // pursue the player for bite
			}
			
			if(irandom(1600) == 0) {
				//random state with no conditions..?
				setState("chargeCast", 130);
			}
		} else if(_playerDist < 320) {
			if(irandom(240) == 0) {
				setState("chargeCast", 130);
			}
		}
	}
} else if(stateType == "attack") {
	if(state == "bite") {
		
		x = lerp(x, player.x, .04);
		y = lerp(y, player.y, .04); // lock tf on
		
		if(point_distance(x, y, player.x, player.y) < 27) {
			x = player.x - dcos(dirToPlayer) * 27;
			y = player.y + dsin(dirToPlayer) * 27;
		}
		
		image_angle += _stuckMoveMultiplier * angle_difference(dirToPlayer, image_angle) / 8; // target player
		
		//var _mouthX = x + dcos(directionFacing) * 30; // ?
		//var _mouthY = y - dsin(directionFacing) * 30;
		
		player.xChange = 0;
		player.yChange = 0; // sucks to suck kid
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
		image_angle += _stuckMoveMultiplier * angle_difference(dirToPlayer, image_angle) / 12; // target player
		 
		 var _speedMultFromDifficulty = array_get([.8, .99, 1.05], global.gameDifficultySelected); // get speeds from difficulty selection, that being said, the speed is very close to being too much so 1.03 is harder than 1 while .85 is quite easy
		 
		xChange += dcos(dirToPlayer) * moveSpeed * .8 * _stuckMoveMultiplier * _speedMultFromDifficulty;
		yChange -= dsin(dirToPlayer) * moveSpeed * .8 * _stuckMoveMultiplier * _speedMultFromDifficulty;
		
		if(point_distance(x, y, player.x, player.y) < 45) {
			setState("bite", 90);
		}
		
		if(stateTimer <= 0) {
			setState("strafe");
		}
	} else if(state == "strafe") {
		if(irandom(300) == 0) {
			strafeDir = choose(-1, 1);
		}
		
		image_angle += _stuckMoveMultiplier * angle_difference(dirToPlayer, image_angle) / 14; // target player
		
		var _distToPlayer = point_distance(x, y, player.x, player.y);
		
		if(_distToPlayer < 65) {
			if(irandom(130) == 0) {
				setState("chase", 80); // pursue the player for bite
			}
			
			xChange += dcos(dirToPlayer + 150 * strafeDir) * moveSpeed * .26 * _stuckMoveMultiplier;
			yChange -= dsin(dirToPlayer + 150 * strafeDir) * moveSpeed * .26 * _stuckMoveMultiplier;
		} else if(_distToPlayer < 90) {
			if(irandom(270) == 0) {
				setState("chase", 120); // pursue the player for bite
			}
			
			xChange += dcos(dirToPlayer + 105 * strafeDir) * moveSpeed * .13 * _stuckMoveMultiplier;
			yChange -= dsin(dirToPlayer + 105 * strafeDir) * moveSpeed * .13 * _stuckMoveMultiplier;
		} else if(_distToPlayer < 170) {
			if(irandom(370) == 0) {
				setState("chase", 150); // pursue the player for bite
			} else if(irandom(800) == 0) {
				setState("chargeCast", 120); // pursue the player for bite
			}
			
			xChange += dcos(dirToPlayer + 50 * strafeDir) * moveSpeed * .23 * _stuckMoveMultiplier;
			yChange -= dsin(dirToPlayer + 50 * strafeDir) * moveSpeed * .23 * _stuckMoveMultiplier;
		} else if(_distToPlayer > 250) {
			if(irandom(180) == 0) {
				setState("idle");
			} else if(irandom(300) == 0) {
				setState("chargeCast", 130);
			}
		} else { // 170 - 250 ?
			xChange += dcos(dirToPlayer + 50 * strafeDir) * moveSpeed * .38 * _stuckMoveMultiplier;
			yChange -= dsin(dirToPlayer + 50 * strafeDir) * moveSpeed * .38 * _stuckMoveMultiplier;
			
			 if(irandom(700) == 0) {
				setState("chargeCast", 120);
			}
		}
	} else if(state == "intro") {
		//?
		if(stateTimer < 120) {
			if(stateTimer < 60) {
				if(global.musicPlaying == -1) {
					global.musicPlaying = snd_rollerSongInitial;
					audio_play_sound(global.musicPlaying, 100, 0);
				}
			}
			xChange = 0;
			yChange = 0;
		} // play some kind of animation here?
		
		if(stateTimer <= 0) {
			setState("strafe");
		}
	}
} else if(stateType == "cast") {
	
	y += dsin(current_time * 1.5) * 1.2 - .25;
	
	if(stateTimer % (26 - global.gameDifficultySelected * 2) == 0) {
		var _speed = random_range(3, 9.5);
		var _dirToCenter = point_direction(x, y, room_width / 2, room_height / 2);
		
		script_createOrbProjectile(x - dcos(image_angle) * 10, y + dsin(image_angle) * 10, lerp(_dirToCenter, irandom(360), random(1)), _speed, sqr(_speed + 4) + 25);
	}
	
	if(stateTimer <= 0) {
		setState("strafe");
	}
}

if(state != "dead" && state != "cast") {
	var _legPos = 0;
	var _legPosGoal = 0;
	var _legOrigin = 0;
	var _legAngle = image_angle + 40;
	for(var _legI = 0; _legI < 8; _legI++) {
		_legPos = legPositions[_legI];
		_legPosGoal = legPositionGoals[_legI];
		_legOrigin = legOrigins[_legI];
	
		_legOrigin[0] = x + dcos(_legAngle) * 16;
		_legOrigin[1] = y - dsin(_legAngle) * 16;
	
		var _goalX = _legOrigin[0] + dcos(_legAngle + random_range(-9, 9)) * legStepDist * random_range(.75, 1.25) + (x - xprevious) * 21; // maybe clamp the prediction values
		var _goalY = _legOrigin[1] - dsin(_legAngle + random_range(-9, 9)) * legStepDist * random_range(.75, 1.25) + (y - yprevious) * 21; // move feet to neutral positions pushed ahead 20x the position change for step pathing improvement
	
		var _legStepDist = point_distance(_goalX, _goalY, _legPos[0], _legPos[1]);
		if(_legStepDist > legUpdateDistance || irandom(180) == 0) {
			legStepDistances[_legI] = point_distance(_legPos[0], _legPos[1], _goalX, _goalY);
			_legPosGoal[0] = _goalX;
			_legPosGoal[1] = _goalY; // set the next step point to the goal positions
		}
	
		// moving the legs to the goals
		_legPos[0] = lerp(_legPos[0], _legPosGoal[0], .16);
		_legPos[1] = lerp(_legPos[1], _legPosGoal[1], .16);
	
		_legAngle += 33; // add between 40 and 140
		if(_legI == 3) {
			_legAngle += 47; // flip from left set of legs to right, these values are all hard coded so no they won't be correct if you change things. Basically though it's 4 legs between 40 and 140 counter clockwise from the head direction then add 80 to do 4 legs 220 to 320
		}
	}
} else {
	for(var _i = 0; _i < 8; _i++) {
		legPositions[_i][0] = lerp(legPositions[_i][0], legPositionGoals[_i][0], .04);
		legPositions[_i][1] = lerp(legPositions[_i][1], legPositionGoals[_i][1], .04);
	}
}