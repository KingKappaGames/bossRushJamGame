event_inherited();

var _dirMoving = point_direction(0, 0, xChange, yChange);

if(xChange >= 0) { // face in direction you're moving (depends on the sprite art direction..
	directionFacing = 1;
} else {
	directionFacing = -1;
}

if(stateType == "idle") {
	var _moveDir = point_direction(x, y, moveGoalX, moveGoalY);

	xChange += (dcos(_moveDir) * moveSpeed)  * (1 - clamp(global.bossStickingOrbs / 10, 0, 1));
	yChange += (-dsin(_moveDir) * moveSpeed) * (1 - clamp(global.bossStickingOrbs / 10, 0, 1)); // with at speed but also move slower the more stuck you are in webs
	
	if(yChange >= 0) {
		//face camera
		sprite_index = spr_rollieForwardStand;
	} else {
		//face away from camera
		sprite_index = spr_rollieBackwardStand;
	}
	
	var _goalDist = point_distance(x, y, moveGoalX, moveGoalY);
	if(_goalDist < 50) {
		moveGoalX = irandom_range(90, room_width - 90);
		moveGoalY = irandom_range(90, room_height - 90);
	}

	if(player != noone) {
		var _playerDist = point_distance(x, y, player.x, player.y);
		 if(_playerDist < 40) {
			if(irandom(50) == 0) { // random chance to melee attack (change as you see fit)
				setState("spinAttack", 60);
			}
		} else if(_playerDist < 200) {
			if(irandom(200) == 0) {
				setState("follow", 180);
				
			} else if(irandom(32 - global.gameDifficultySelected * 3) == 0) {
				var _shotDir = point_direction(x, y, player.x, player.y);
				script_createBullet(1 + irandom(2), x, y, _shotDir + irandom_range(-13, 13), 4.2);
			} else if(irandom(300) == 0) {
				setState("chargingBurst", 40);
			}
		}
		
		if(irandom(1500) == 0) {
			setState("chargingRoll", 120);
		}
	}
} else if(stateType == "move") {
	if(state == "follow") {
		xChange += dcos(dirToPlayer) * moveSpeed;
		yChange -= dsin(dirToPlayer) * moveSpeed;
		
		with(obj_webOrb) {
			if(irandom(600) == 0) {
				snap();
			}
		}
	
		if(point_distance(x, y, player.x, player.y) < 70) {
			setState("slam", 80);
		}
	} 
	
	if(stateTimer <= 0) {
		setState("idle");
	}
} else if(stateType == "attack") {
	if(state == "spinAttack") {
		directionFacing = dsin(current_time * 1.25);
	
		var _dir = irandom(360);
		var _dist = irandom_range(20, 125); // attack range roughly for particle spawning, not super strict obviously
	
		part_type_direction(swirlParticle, _dir + 85, _dir + 95, 6, 0);
		part_particles_create(partSys, x + dcos(_dir) * _dist, y - dsin(_dir) * _dist, swirlParticle, 1);
	} else if(state == "rolling") {
		image_angle += 10 * directionFacing;
		
		if((_dirMoving > 135 && _dirMoving < 225) || (_dirMoving < 45 || _dirMoving > 315)) { // if largely going horizontal (otherwise you slide on the sides but don't "collide", i dunno, take this out if you don't like the soft wall touches... One of the sides has to collide like this so...
			if(x <= 40 || x >= room_width - 40) { // if hit wall horizontal
				xChange *= -.3;
				script_cameraShake(20);
				setState("idle");
			}
		} else if((_dirMoving < 315 && _dirMoving > 225) || (_dirMoving > 45 && _dirMoving < 135)) { // if largely going horizontal (otherwise you slide on the sides but don't "collide", i dunno, take this out if you don't like the soft wall touches... One of the sides has to collide like this so...
			if(y <= 40 || y >= room_width - 40) { // if hit wall horizontal
				yChange *= -.3;
				script_cameraShake(16);
				setState("idle");
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
		if(stateTimer / stateTimerMax > .58 && stateTimer / stateTimerMax < .68) {
			image_angle = directionFacing * -90;
			
			part_particles_create(partSys, x + 40 * directionFacing + irandom_range(-40, 40), y + irandom_range(-40, 40), dustParticle, 10);
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
			var _dir = dirToPlayer + irandom_range(-6, 6);
			xChange = dcos(_dir) * 6.3; // shoot out roughly at player
			yChange = -dsin(_dir) * 6.3;
			
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
			audio_stop_sound(global.musicActualPlaying);
			global.musicPlaying = snd_rollerSongInitial;
			global.musicActualPlaying = audio_play_sound(global.musicPlaying, 100, 0);
		}
		yChange = 0;
	} else if(stateTimer < stateTimerMax * .5) {
		if(image_xscale < 1) {
			script_cameraShake(.024);
			part_particles_create(partSys, x + 4 + irandom_range(-40, 40), y + irandom_range(-40, 40), dustParticle, 2);
			image_xscale += .01;
			image_yscale += .01;
		}
	} else {
		script_cameraShake(.021);
	}
	
	if(stateTimer <= 0) {
		setState("idle", 180);
	}
} else if(state == "shot") {
	if(stateTimer == 15) {
		script_cameraShake(9);
		repeat(irandom_range(4, 9)) {
			var _shotDir = dirToPlayer + irandom_range(-15, 15) + irandom_range(-15, 15); // stacked variance
			script_createBullet(4 + irandom(3), x + dcos(dirToPlayer) * 17, y - dsin(dirToPlayer) * 17, _shotDir, irandom_range(2.6, 4.8), true, obj_terrainShot, irandom_range(50, 150));
		}
	}
	
	if(stateTimer <= 0) {
		setState("idle");
	}
}