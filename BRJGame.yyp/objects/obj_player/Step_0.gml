depth = -(y + 12);

directionToMouse = point_direction(x, y, mouse_x, mouse_y);

#region movement and controls
if(state == "idle") {
	if(keyboard_check(ord("W"))) {
		yChange -= moveSpeed;
	}

	if(keyboard_check(ord("S"))) {
		yChange += moveSpeed;
	}

	if(keyboard_check(ord("A"))) {
		xChange -= moveSpeed;
	}

	if(keyboard_check(ord("D"))) {
		xChange += moveSpeed;
	}

	if(jumpCooldown <= 0) {
		if(keyboard_check_released(vk_space)) {
			setState("jump", 23 - global.gameDifficultySelected); // game difficulty shortens jumps lol
		}
	} else {
		jumpCooldown--;
	}
	
	if(keyboard_check_pressed(vk_shift)) {		
		setState("spin");
	}
	
	if(keyboard_check_released(ord("E"))) {
		var _orb = instance_create_layer(x, y, "Instances", array_get([obj_fireOrb, obj_webOrb, obj_iceOrb], orbSpawnType));
		audio_play_sound(snd_orbPlaceHuff, 1, 0, 2);
		part_particles_create_color(sys, x, y + 4, fluffPart, array_get([c_orange, c_ltgray, #00ffff], orbSpawnType), irandom_range(3, 6));
	}
} else if(state == "spin") {
	if(keyboard_check_released(vk_shift)) {
		setState("idle");
	} else {
		var _dirFromCenter = point_direction(spinCenterX, spinCenterY, x, y);
		
		if(abs(angle_difference(spinLastAngleOrb, _dirFromCenter)) > 2100 / spinDist) { // well... this basically creates an orb web every few degrees of travel but more on bigger circles becauese bigger circle = more distance per angle traveleed.... Don't ask me to be reasonable
			var _orb = instance_create_layer(x, y, "Instances", obj_webOrb);
			if(instance_exists(spinLastOrbId)) {
				_orb.linkOrb(spinLastOrbId);
			}
			spinLastOrbId = _orb;
			
			spinLastAngleOrb = _dirFromCenter;
		}
		
		if(keyboard_check(ord("W"))) {
			var _poiX = spinCenterX + dcos(_dirFromCenter + (300 / spinDist)) * spinDist;
			var _poiY = spinCenterY - dsin(_dirFromCenter + (300 / spinDist)) * spinDist;
			
			var _dirToPoi = point_direction(x, y, _poiX, _poiY);
			xChange += dcos(_dirToPoi) * moveSpeed * 3;
			yChange -= dsin(_dirToPoi) * moveSpeed * 3;
		} else if(keyboard_check(ord("S"))) {
			var _poiX = spinCenterX + dcos(_dirFromCenter - (300 / spinDist)) * spinDist;
			var _poiY = spinCenterY - dsin(_dirFromCenter - (300 / spinDist)) * spinDist;
			
			var _dirToPoi = point_direction(x, y, _poiX, _poiY);
			xChange += dcos(_dirToPoi) * moveSpeed * 3;
			yChange -= dsin(_dirToPoi) * moveSpeed * 3;
		}

		if(keyboard_check(ord("A"))) {
			spinDist -= 2;
		}

		if(keyboard_check(ord("D"))) {
			spinDist += 2;
		}
	}
} else if(state == "intro") {
	x = lerp(x, introGoalX, .01);
	y = lerp(y, introGoalY, .01);
	image_angle += angle_difference(point_direction(xprevious, yprevious, x, y), image_angle) / 10;
} else if(state == "jump") {	
	#region pull legs in
	var _legPos = 0;
	var _legPosGoal = 0;
	var _legOrigin = 0;
	var _legAngle = image_angle + 40;
	
	var _jumpHeight = 27 * dsin(180 * (stateTimer / stateTimerMax));
	var _feetJumpHeight = 33 * dsin(180 * clamp(-.4 + (stateTimer / stateTimerMax) * 1.8, 0, 1));
	
	for(var _legI = 0; _legI < 8; _legI++) {
		_legPos = legPositions[_legI];
		_legPosGoal = legPositionGoals[_legI];
		_legOrigin = legOrigins[_legI];
	
		_legOrigin[0] = x + dcos(_legAngle) * 7;
		_legOrigin[1] = y - dsin(_legAngle) * 7 - _jumpHeight;
	
		var _goalX = _legOrigin[0] + dcos(_legAngle) * legStepDist;
		var _goalY = _legOrigin[1] - dsin(_legAngle) * legStepDist;
		
		_legPosGoal[0] = _goalX;
		_legPosGoal[1] = _goalY + _jumpHeight - _feetJumpHeight; // set the next step point to the goal positions
		_legPos[0] = _goalX;
		_legPos[1] = _goalY + _jumpHeight - _feetJumpHeight;
	
		_legAngle += 33; // add between 40 and 140
		if(_legI == 3) {
			_legAngle += 47; // flip from left set of legs to right, these values are all hard coded so no they won't be correct if you change things. Basically though it's 4 legs between 40 and 140 counter clockwise from the head direction then add 80 to do 4 legs 220 to 320
		}
	}
	#endregion
	
	var _orb = instance_nearest(x, y, obj_orbParent);
	if(instance_exists(_orb)) {
		var _dist = point_distance(x, y, _orb.x, _orb.y);
		if(_dist < 30) {
			var _dir = point_direction(x, y, _orb.x, _orb.y);
			xChange += dcos(_dir + 180) * 2;
			yChange -= dsin(_dir + 180) * 2;
			xChange *= .5;
			yChange *= .5;
			
			_orb.xChange += dcos(_dir) * 2;
			_orb.yChange -= dsin(_dir) * 2;
			
			setState("knock", 25);
		}
	}
	
	if(stateTimer <= 1) {
		xChange *= .68;
		yChange *= .68; // slow down before last frame to avoid leg pushing
	}
} else if(state == "squish") {
	// haha you are squish
}

if(global.gameManager.gameState == "fight") {
	x = clamp(x + xChange, 0, room_width);
	y = clamp(y + yChange, 60, room_height - 60);
} else {
	if(x < -room_width * .4 || x > room_width * 1.4) {
		if(!audio_is_playing(snd_waves)) {
			if(irandom(70) == 0) {
				audio_play_sound(snd_waves, 0, 0);
			}
		}
	}
	
	var _left = 0;
	var _right = 0;
	if(sign(x) == -1) {
		_left = -room_width * 1.5;
		_right = -room_width * .73;
	} else {
		_left = room_width * 1.73;
		_right = room_width * 2.5;
	}
	
	repeat(2) {
		part_particles_create(underSys, irandom_range(_left, _right), irandom(room_height), waterParts, 1);
	}
	
	if(global.gameManager.gameState == "sail") {
		//don't flip with sailing
	} else { // other times...
		
		x = clamp(x + xChange, -room_width * .71, room_width * 1.755); // how wide is continued area?
	
		if(abs(y - room_height / 2) > 50) { // the middle path in the rooma
			if(x > room_width) {
				x = room_width;
			} else if(x < 0) {
				x = 0;
			}
		}
	
		if(x <= room_width + 1 && x >= 0) { // if in extra area
			y = clamp(y + yChange, 50, room_height - 30);
		} else {
			y = clamp(y + yChange, room_height / 2 - 49, room_height / 2 + 49);
		}
	}
}

if(state != "jump") {		
	//var _anglePushSpiderDirection = angle_difference(point_direction(0, 0, xChange, yChange), directionFacing);
	if(state != "jump" && state != "knock") {
		if(abs(xChange) + abs(yChange) > .1) {
			image_angle += angle_difference(point_direction(0, 0, xChange, yChange), image_angle) / 10;
		}
	} else if(state == "knock") {
		image_angle += 10;
	}
}

xChange *= speedDecay;
yChange *= speedDecay;

if(state != "idle") {
	if(stateTimer != infinity) {
		stateTimer--;
		if(stateTimer <= 0) {
			setState("idle");
		}
	}
}

if(immunityFrames > 0) {
	immunityFrames--;
}

if(hitColorTimer > 0) {
	hitColorTimer--;
	if(hitColorTimer <= 0) {
		image_blend = c_white;
	}
}

highlightHealth = lerp(highlightHealth, Health, .035);

if(state != "dead" && state != "sail" && state != "squish") {
	if(mouse_check_button_released(mb_left)) {
		var _heldOrbType = obj_orbParent;
		if(instance_exists(orbLinkFromId)) {
			_heldOrbType = orbLinkFromId.object_index; // only try to connect to orbs of the same kind as the one you're holding or all if none held currently
		}
		
		var _orbNearest = instance_nearest(mouse_x, mouse_y, _heldOrbType);
		if(instance_exists(_orbNearest)) {
			var _orbDist = point_distance(_orbNearest.x, _orbNearest.y, x, y);
			if(_orbDist < orbClickRange) {
				if(instance_exists(orbLinkFromId)) { // coming from one orb to the next
					if(script_checkOrbsConnected(_orbNearest, orbLinkFromId) == false) { // can be -1 or bool
						_orbNearest.linkOrb(orbLinkFromId);
						orbLinkFromId = _orbNearest;
					}
				} else {
					orbLinkFromId = _orbNearest;
				}
			}
		
		}
	}

	if(mouse_check_button_released(mb_right)) {
		if(orbLinkFromId == noone) {
			orbSpawnType = (orbSpawnType + 1) % 3;
		} else {
			orbLinkFromId = noone;
		}
	}

	#endregion

	var _bulletNearest = instance_nearest(x, y, obj_bullet);
	if(_bulletNearest != noone) {
		if(_bulletNearest.flying) {
			if(point_distance(x, y, _bulletNearest.x, _bulletNearest.y) < _bulletNearest.hitRadius) { // 12 is just player width plus a little
				takeHit(_bulletNearest.damage, 1, point_direction(_bulletNearest.x, _bulletNearest.y, x, y), 25); // random stuff related to combat that doesn't need to run while sailing...
				_bulletNearest.hit();
			}
		}
	}
}

#region leg stuff
if(state != "dead" && state != "squish" && state != "jump") {
	var _legPos = 0;
	var _legPosGoal = 0;
	var _legOrigin = 0;
	var _legAngle = image_angle + 40;
	for(var _legI = 0; _legI < 8; _legI++) {
		_legPos = legPositions[_legI];
		_legPosGoal = legPositionGoals[_legI];
		_legOrigin = legOrigins[_legI];
	
		_legOrigin[0] = x + dcos(_legAngle) * 6;
		_legOrigin[1] = y - dsin(_legAngle) * 6;
	
		var _goalX = _legOrigin[0] + dcos(_legAngle + random_range(-9, 9)) * legStepDist * random_range(.75, 1.25) + clamp((x - xprevious) * 15, -36, 36);
		var _goalY = _legOrigin[1] - dsin(_legAngle + random_range(-9, 9)) * legStepDist * random_range(.75, 1.25) + clamp((y - yprevious) * 15, -36, 36); // move feet to neutral positions pushed ahead 20x the position change for step pathing improvement
	
		var _legStepDist = point_distance(_goalX, _goalY, _legPos[0], _legPos[1]);
		if(_legStepDist > legUpdateDistance || irandom(180) == 0) { // randly replace the step even if it's not out of range, this helps to center a stopped leg and also add random choice to the leg pattern
			_legPosGoal[0] = _goalX;
			_legPosGoal[1] = _goalY; // set the next step point to the goal positions
			if(irandom(1) == 0) { // it's a lot of steps so.. cut out half of them
				audio_play_sound(snd_playerStep, 0, 0);
			}
		}
	
		// moving the legs to the goals
		_legPos[0] = lerp(_legPos[0], _legPosGoal[0], .17);
		_legPos[1] = lerp(_legPos[1], _legPosGoal[1], .17);
	
		_legAngle += 33; // add between 40 and 140
		if(_legI == 3) {
			_legAngle += 47; // flip from left set of legs to right, these values are all hard coded so no they won't be correct if you change things. Basically though it's 4 legs between 40 and 140 counter clockwise from the head direction then add 80 to do 4 legs 220 to 320
		}
	}
	
	if(instance_exists(orbLinkFromId)) {
		handX = mouse_x;
		handY = mouse_y;

		if(point_distance(handX, handY, x, y) > handDist) {
			handX = x + dcos(directionToMouse) * handDist;
			handY = y - dsin(directionToMouse) * handDist;
		}
		
		legPositionGoals[7][0] = handX;
		legPositionGoals[7][1] = handY;
		legPositions[7][0] = handX;
		legPositions[7][1] = handY;
	}
} else {
	for(var _i = 0; _i < 8; _i++) {
		legPositions[_i][0] = lerp(legPositions[_i][0], legPositionGoals[_i][0], .06);
		legPositions[_i][1] = lerp(legPositions[_i][1], legPositionGoals[_i][1], .06);
	}
}
#endregion leg stuff