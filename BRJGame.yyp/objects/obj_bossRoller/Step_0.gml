event_inherited();

var _dirMoving = point_direction(0, 0, xChange, yChange);

if(xChange > 0) { // face in direction you're moving (depends on the sprite art direction..
	directionFacing = 1;
} else if(xChange < 0) {
	directionFacing = -1;
}

if(stateType == "idle") {
	var _moveDir = point_direction(x, y, moveGoalX, moveGoalY);

	xChange += (dcos(_moveDir) * moveSpeed * .75)  * (1 - clamp(global.bossStickingOrbs / 10, 0, 1));
	yChange += (-dsin(_moveDir) * moveSpeed * .75) * (1 - clamp(global.bossStickingOrbs / 10, 0, 1)); // with at speed but also move slower the more stuck you are in webs
	
	if(yChange >= 0) {
		//face camera
		sprite_index = spr_rollieForwardCrawl;
	} else {
		//face away from camera
		sprite_index = spr_rollieForwardCrawl;
	}
	
	var _goalDist = point_distance(x, y, moveGoalX, moveGoalY);
	if(_goalDist < 50) {
		moveGoalX = irandom_range(90, room_width - 90);
		moveGoalY = irandom_range(90, room_height - 90);
	}

	if(player != noone) {
		var _playerDist = point_distance(x, y, player.x, player.y);
		 if(_playerDist < 40) {
			if(irandom(70) == 0) {
				setState("follow", 50);
			}
		} else if(_playerDist < 200) {
			if(irandom(175) == 0) {
				setState("follow", 180);
			} else if(irandom(32 - global.gameDifficultySelected * 3) == 0) {
				var _shotDir = point_direction(x, y, player.x, player.y);
				script_createBullet(1 + irandom(2), x, y, _shotDir + irandom_range(-13, 13), 4.2);
			} else if(irandom(300) == 0) {
				setState("chargingBurst", 40);
			}
		}
		
		if(irandom(1300) == 0) {
			setState("chargingRoll", 120);
		}
	}
	
	if(irandom(2) == 0) {
		part_particles_create(floorSys, x + irandom_range(-25, 15), y + irandom_range(-25, 25), dustParticle, 1);
	}
} else if(stateType == "move") {
	if(irandom(2) == 0) {
		part_particles_create(floorSys, x + irandom_range(-25, 25), y + irandom_range(-25, 25), dustParticle, 1);
	}
	
	if(state == "follow") {
		xChange += dcos(dirToPlayer) * moveSpeed * (1 - clamp(global.bossStickingOrbs / 10, 0, 1));
		yChange -= dsin(dirToPlayer) * moveSpeed * (1 - clamp(global.bossStickingOrbs / 10, 0, 1));
	
		if(point_distance(x, y, player.x, player.y) < 70) {
			setState("slam", 75 - global.gameDifficultySelected * 10);
		}
	} 
	
	if(stateTimer <= 0) {
		setState("idle");
	}
} else if(stateType == "attack") {
	/*if(state == "spinAttack") {
		with(obj_webOrb) {
			if(irandom(480) == 0) {
				snap();
			}
		}
		
		directionFacing = dsin(current_time * 1.25);
	
		var _dir = irandom(360);
		var _dist = irandom_range(20, 125); // attack range roughly for particle spawning, not super strict obviously
	
		part_type_direction(swirlParticle, _dir + 85, _dir + 95, 6, 0);
		part_particles_create(partSys, x + dcos(_dir) * _dist, y - dsin(_dir) * _dist, swirlParticle, 1);
	} else */if(state == "rolling") {
		with(obj_webOrb) {
			if(irandom(700) == 0) {
				snap();
			}
		}
		
		if((_dirMoving > 135 && _dirMoving < 225) || (_dirMoving < 45 || _dirMoving > 315)) { // if largely going horizontal (otherwise you slide on the sides but don't "collide", i dunno, take this out if you don't like the soft wall touches... One of the sides has to collide like this so...
			if(x <= 40 || x >= room_width - 40) { // if hit wall horizontal
				xChange *= -.3;
				script_cameraShake(20);
				setState("bounce", 50);
				audio_play_sound(snd_rollerCrash, 1, 0, 2);
			}
		} else if((_dirMoving < 315 && _dirMoving > 225) || (_dirMoving > 45 && _dirMoving < 135)) { // if largely going horizontal (otherwise you slide on the sides but don't "collide", i dunno, take this out if you don't like the soft wall touches... One of the sides has to collide like this so...
			if(y <= 40 || y >= room_width - 40) { // if hit wall horizontal
				yChange *= -.3;
				script_cameraShake(16);
				setState("bounce", 50);
				audio_play_sound(snd_rollerCrash, 1, 0, 2);
			}
		}
		
		var _partDir = _dirMoving + irandom_range(-90, 90);
		
		if(_partDir < _dirMoving) { // clockwise
			part_type_direction(plowParticle, _dirMoving - 130, _dirMoving - 50, 0, 0);
		} else {
			part_type_direction(plowParticle, _dirMoving + 50, _dirMoving + 130, 0, 0);
		}
		
		var _partDist = irandom_range(21, 32);
		part_particles_create(partSys, x + dcos(_partDir) * _partDist, y - dsin(_partDir) * _partDist, plowParticle, 2);
	} else if(state == "slam") {
		with(obj_webOrb) {
			if(irandom(1200) == 0) {
				snap();
			}
		}
		
		if(stateTimer / stateTimerMax > .33 && stateTimer / stateTimerMax < .53) {
			if(sprite_index != spr_rollieForwardCrawl) {
				sprite_index = spr_rollieForwardCrawl;
				audio_play_sound(snd_rollerCrash, 0, 0, 1.25);
			}
			var _yComp = attackTimings[0][4];
			if(_yComp /*the x offset*/ != 0) {
				part_particles_create(partSys, x + irandom_range(-40, 40), y - _yComp + irandom_range(-40, 40), dustParticle, 10);
			} else {
				part_particles_create(partSys, x + 40 * directionFacing + irandom_range(-40, 40), y + irandom_range(-40, 40), dustParticle, 10);
			}
		} else if(stateTimer / stateTimerMax > .55 && stateTimer / stateTimerMax < .88) {
			if(point_distance(x, y, player.x, player.y) < 25) { // also check to bonk player from crossing boss while charging, this doesn't do damage but prevents clipping and easy dodges via going straight through
				player.takeHit(0, 7.1, point_direction(x, y, player.x, player.y), 0);
			}
		}
	}
	
	script_doHitboxCollisionsAndDamage();
	
	if(stateTimer <= 0) {
		setState("idle");
	}
} else if(stateType == "charge") {
	if(state == "chargingRoll") {
		//... count down timer then start roll attack
		if(stateTimer <= 0) {
			var _dir = dirToPlayer + irandom_range(-5 - global.gameDifficultySelected * 2, 5 + global.gameDifficultySelected * 2);
			xChange = dcos(_dir) * 6 + global.gameDifficultySelected * .7 * (1 - clamp(global.bossStickingOrbs / 20, .6, 1)); // shoot out roughly at player
			yChange = -dsin(_dir) * 6 - global.gameDifficultySelected * .7 * (1 - clamp(global.bossStickingOrbs / 20, .6, 1));
			
			setState("rolling", 180);
		}
	} else if(state == "chargingBurst") {
		if(stateTimer <= 0) {
			setState("shot", 30);
		}
	}
} else if(stateType == "intro") {
	if(stateTimer < stateTimerMax * .1) {
		if(!audio_is_playing(global.musicActualPlaying)) {
			audio_play_sound(snd_rollerRoar, 0, 0, 1);
			audio_stop_sound(global.musicActualPlaying);
			global.musicPlaying = snd_rollerSongInitial;
			global.musicActualPlaying = audio_play_sound(global.musicPlaying, 100, 0);
		}
		yChange = 0;
	} else if(stateTimer < stateTimerMax * .43) {
		if(image_xscale < 1) {
			script_cameraShake(.024);
			part_particles_create(partSys, x + 4 + irandom_range(-40, 40), y + irandom_range(-40, 40), dustParticle, 2);
			image_xscale += .01;
			image_yscale += .01;
			if(image_xscale > .5) {
				visible = true;
			}
		}
	} else {
		script_cameraShake(.021);
	}
	
	if(stateTimer <= 0) {
		setState("idle", 180);
	}
} else if(state == "shot") {
	if(stateTimer == 15) {
		sprite_index = spr_rollieForwardCrawl;
		part_particles_create(partSys, x + 35 * directionFacing + irandom_range(-25, 25), y + irandom_range(-25, 25), dustParticle, 20);
		script_cameraShake(9);
		repeat(irandom_range(4, 9)) {
			var _shotDir = dirToPlayer + irandom_range(-15, 15) + irandom_range(-15, 15); // stacked variance
			script_createBullet(4 + irandom(3), x + dcos(dirToPlayer) * 17, y - dsin(dirToPlayer) * 17, _shotDir, irandom_range(2.6, 4.8), true, obj_terrainShot, irandom_range(50, 150));
		}
	}
	
	if(stateTimer <= 0) {
		setState("idle");
	}
} else if(state == "dead") {
	part_particles_create(partSys, x + 25 * directionFacing + irandom_range(-30, 30), y + irandom_range(-30, 30), dustParticle, 14);
	
	if(stateTimer <= 0) {
		instance_destroy();
	}
}

if(state != "dead") {	
	var _moveDir = (90 - 90 * directionFacing);
	
	#region update a single leg on a looping basis (this update happens in one step, hence why it's split off)
	var _updateLegPair = updateLeg div 2;
	
	var _cos = dcos(_moveDir);
	var _sin = dsin(_moveDir);
	
	var _legPairX = x - _cos * 30 + (_cos * 12 * _updateLegPair); // start 30 behind
	var _legPairY = y + _sin * 30 - (_sin * 12 * _updateLegPair);
	
	var _legPos = legPositions[updateLeg];
	var _legPosGoal = legPositionGoals[updateLeg];
	var _legOrigin = legOrigins[updateLeg];
	var _legAngle = _moveDir + 90 + 180 * (updateLeg % 2);
	
	_legOrigin[0] = _legPairX + dcos(_legAngle) * 6;
	_legOrigin[1] = _legPairY - dsin(_legAngle) * 6;
	
	var _goalX = _legOrigin[0] + dcos(_legAngle + random_range(-2, 2)) * legStepDist * random_range(.88, 1.1) + (x - xprevious) * 14; // maybe clamp the prediction values 
	var _goalY = _legOrigin[1] - dsin(_legAngle + random_range(-2, 2)) * legStepDist * random_range(.88, 1.1) + (y - yprevious) * 14; // move feet to neutral positions pushed ahead 20x the position change for step pathing improvement
	
	var _legStepDist = point_distance(_goalX - (x - xprevious) * 14, _goalY - (y - yprevious) * 14, _legPos[0], _legPos[1]);
	if(_legStepDist > legUpdateDistance || irandom(240) == 0) {
		legStepDistances[updateLeg] = point_distance(_legPos[0], _legPos[1], _goalX, _goalY);
		_legPosGoal[0] = _goalX;
		_legPosGoal[1] = _goalY; // set the next step point to the goal positions
	}
	#endregion
	
	
	_legPairX = x - dcos(_moveDir) * 30; // start 30 behind
	_legPairY = y + dsin(_moveDir) * 30;
	_legAngle = _moveDir + 90;
	
	// moving the legs to the goals
	for(var _legI = 0; _legI < legPairsOnGround * 2; _legI++) {
		_legPos = legPositions[_legI];
		_legPosGoal = legPositionGoals[_legI];
		_legOrigin = legOrigins[_legI];
		
		_legOrigin[0] = _legPairX + dcos(_legAngle) * 6;
		_legOrigin[1] = _legPairY - dsin(_legAngle) * 6;
		_legAngle += 180;
		
		if((_legI + 1) % 2 == 0) {
			_legPairX += dcos(_moveDir) * 7;
			_legPairY -= dsin(_moveDir) * 7;
		}
		
		_legPos[0] = lerp(_legPos[0], _legPosGoal[0], .3);
		_legPos[1] = lerp(_legPos[1], _legPosGoal[1], .3);
	}
	
	updateLeg++;
	if(updateLeg >= legPairsOnGround * 2) {
		updateLeg = 0;
	}

} else {
	for(var _i = 0; _i < 14; _i++) {
		legPositions[_i][0] = lerp(legPositions[_i][0], legPositionGoals[_i][0], .07);
		legPositions[_i][1] = lerp(legPositions[_i][1], legPositionGoals[_i][1], .07);
	}
}