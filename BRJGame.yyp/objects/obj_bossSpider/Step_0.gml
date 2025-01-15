event_inherited();

var _dirMoving = point_direction(0, 0, xChange, yChange);

if(stateType == "idle") {
	var _moveDir = point_direction(x, y, moveGoalX, moveGoalY);

	xChange += dcos(_moveDir) * moveSpeed  * (1 - clamp(global.bossStickingOrbs / 10, 0, 1));
	yChange += -dsin(_moveDir) * moveSpeed * (1 - clamp(global.bossStickingOrbs / 10, 0, 1)); // with at speed but also move slower the more stuck you are in webs
	
	var _goalDist = point_distance(x, y, moveGoalX, moveGoalY);
	if(_goalDist < 50) {
		moveGoalX = irandom(room_width);
		moveGoalY = irandom(room_height);
	}
	
	image_angle += angle_difference(point_direction(0, 0, xChange, yChange), image_angle) / 10;

	if(player != noone) {
		var _playerDist = point_distance(x, y, player.x, player.y);
		 if(_playerDist < 40) {
			if(irandom(50) == 0) { // random chance to melee attack (change as you see fit)
				setState("spinAttack", 60);
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
}

var _legPos = 0;
var _legPosGoal = 0;
var _legOrigin = 0;
var _legAngle = image_angle + 40;
for(var _legI = 0; _legI < 8; _legI++) {
	_legPos = legPositions[_legI];
	_legPosGoal = legPositionGoals[_legI];
	_legOrigin = legOrigins[_legI];
	
	_legOrigin[0] = x + dcos(_legAngle) * 15;
	_legOrigin[1] = y - dsin(_legAngle) * 15;
	
	var _goalX = _legOrigin[0] + dcos(_legAngle) * legStepDist + xChange * 20;
	var _goalY = _legOrigin[1] - dsin(_legAngle) * legStepDist + yChange * 20; // move feet to neutral positions pushed ahead 20x the speed for step pathing improvement
	
	var _legStepDist = point_distance(_goalX, _goalY, _legPos[0], _legPos[1]);
	if(_legStepDist > legUpdateDistance) {
		_legPosGoal[0] = _goalX;
		_legPosGoal[1] = _goalY; // set the next step point to the goal positions
	}
	
	// moving the legs to the goals
	_legPos[0] = lerp(_legPos[0], _legPosGoal[0], .13);
	_legPos[1] = lerp(_legPos[1], _legPosGoal[1], .13);
	
	_legAngle += 33; // add between 40 and 140
	if(_legI == 3) {
		_legAngle += 47; // flip from left set of legs to right, these values are all hard coded so no they won't be correct if you change things. Basically though it's 4 legs between 40 and 140 counter clockwise from the head direction then add 80 to do 4 legs 220 to 320
	}
}