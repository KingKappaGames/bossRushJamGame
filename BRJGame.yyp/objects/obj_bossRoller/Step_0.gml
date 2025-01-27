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
		moveGoalX = irandom(room_width);
		moveGoalY = irandom(room_height);
	}

	if(player != noone) {
		var _playerDist = point_distance(x, y, player.x, player.y);
		 if(_playerDist < 40) {
			if(irandom(50) == 0) { // random chance to melee attack (change as you see fit)
				setState("spinAttack", 60);
			}
		} else if(_playerDist < 200) {
			if(irandom(30) == 0) {
				var _shotDir = point_direction(x, y, player.x, player.y);
				script_createBullet(1 + irandom(2), x, y, _shotDir + irandom_range(-7, 7), 3);
			} else if(irandom(300) == 0) {
				setState("chargingBurst", 50);
			}
		}
		
		if(irandom(1500) == 0) {
			setState("chargingRoll", 120);
		}
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
				script_cameraShake(16);
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
			xChange = dcos(_dir) * 5; // shoot out roughly at player
			yChange = -dsin(_dir) * 5;
			
			setState("rolling", 180);
		}
	} else if(state == "chargingBurst") {
		if(stateTimer <= 0) {
			setState("shot", 40);
		}
	}
} else if(stateType == "intro") {
	if(stateTimer < stateTimerMax * .1) {
		if(global.musicPlaying == -1) {
			global.musicPlaying = snd_rollerSongInitial;
			audio_play_sound(global.musicPlaying, 100, 0);
		}
		yChange = 0;
	} else if(stateTimer < stateTimerMax * .5) {
		if(image_xscale < 1) {
			script_cameraShake(.038);
			part_particles_create_color(partSys, x + irandom_range(-40, 40), y + irandom_range(-40, 40), dustParticle, #553920, 2);
			image_xscale += .01;
			image_yscale += .01;
		}
	} else {
		script_cameraShake(.028);
	}
	
	if(stateTimer <= 0) {
		setState("idle", 180);
	}
} else if(state == "shot") {
	if(stateTimer == 15) {
		repeat(irandom_range(5, 9)) {
			var _shotDir = dirToPlayer + irandom_range(-10, 10) + irandom_range(-10, 10) + irandom_range(-10, 10); // stacked variance
			script_createBullet(4 + irandom(3), x + dcos(dirToPlayer) * 17, y - dsin(dirToPlayer) * 17, _shotDir, irandom_range(2.6, 4.8), true, obj_terrainShot, irandom_range(50, 90));
		}
	}
	
	if(stateTimer <= 0) {
		setState("idle");
	}
}