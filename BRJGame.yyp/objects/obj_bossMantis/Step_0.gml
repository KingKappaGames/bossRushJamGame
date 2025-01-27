event_inherited();

var _dirMoving = point_direction(0, 0, xChange, yChange);
/*
if(stateType == "idle") {
	var _moveDir = point_direction(x, y, moveGoalX, moveGoalY);

	xChange += dcos(_moveDir) * moveSpeed  * (1 - clamp(global.bossStickingOrbs / 10, 0, 1));
	yChange += -dsin(_moveDir) * moveSpeed * (1 - clamp(global.bossStickingOrbs / 10, 0, 1)); // with at speed but also move slower the more stuck you are in webs
	
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
				var _shotDir = irandom(360);
				repeat(8) {
					script_createBullet(2 + irandom(1), x, y, _shotDir + irandom_range(-10, 10), 3);
					_shotDir += 45;
				}
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
				script_cameraShake(13);
				setState("idle");
			}
		} else if((_dirMoving < 315 && _dirMoving > 225) || (_dirMoving > 45 && _dirMoving < 135)) { // if largely going horizontal (otherwise you slide on the sides but don't "collide", i dunno, take this out if you don't like the soft wall touches... One of the sides has to collide like this so...
			if(y <= 40 || y >= room_width - 40) { // if hit wall horizontal
				yChange *= -.3;
				script_cameraShake(13);
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
	}
}*/