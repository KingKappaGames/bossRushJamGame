depth = -y; // el classico, que quapo

var _dirToPlayer = -1;
if(!instance_exists(player)) {
	player = noone;
} else {
	_dirToPlayer = point_direction(x, y, player.x, player.y);
	x += dcos(_dirToPlayer) * 1;
	y -= dsin(_dirToPlayer) * 1; // push boss towards player, remove in future if better ai has been made... lol
}

var _moveDir = point_direction(x, y, moveGoalX, moveGoalY);

xChange += dcos(_moveDir) * moveSpeed  * (1 - clamp(global.bossStickingOrbs / 10, 0, 1));
yChange += -dsin(_moveDir) * moveSpeed * (1 - clamp(global.bossStickingOrbs / 10, 0, 1)); // with at speed but also move slower the more stuck you are in webs

if(blockingLinksRef != 0) { // get web blocks
	for(var _i = array_length(blockingLinksRef) - 1; _i >= 0; _i--) {
		var _orbPair = blockingLinksRef[_i];
		if(_orbPair[0].fakeOrb == false && _orbPair[1].fakeOrb == false) {
			if(script_checkLineIntersectsLine(_orbPair[0].x, _orbPair[0].y, _orbPair[1].x, _orbPair[1].y, x - xChange * 4, y - yChange * 4, x + xChange * 4, y + yChange * 4, true)) { // check all web links for collision with this boss and create fake collision point if so
				script_createWebStuckPoint(id, _orbPair); // blocking links is a sub array of both orbs in the link, perfect for this
			}
		}
	}
}

if(xChange >= 0) { // face in direction you're moving (depends on the sprite art direction..
	directionFacing = 1;
} else {
	directionFacing = -1;
}

x = clamp(x + xChange, 0, room_width);
y = clamp(y + yChange, 0, room_height);

xChange *= speedDecay;
yChange *= speedDecay;

if(state == "idle") {
	var _goalDist = point_distance(x, y, moveGoalX, moveGoalY);
	if(_goalDist < 50) {
		moveGoalX = irandom(room_width);
		moveGoalY = irandom(room_height);
	}

	if(player != noone) {
		var _playerDist = point_distance(x, y, player.x, player.y);
		 if(_playerDist < 50) {
			if(irandom(50) == 0) { // random chance to melee attack (change as you see fit)
				setState("attack", 60);
			}
		} else if(_playerDist < 200) {
			if(irandom(30) == 0) {
				var _shotDir = point_direction(x, y, player.x, player.y);
				script_createBullet(1 + irandom(2), x, y, _shotDir, 3);
			} else if(irandom(300) == 0) {
				var _shotDir = irandom(360);
				repeat(8) {
					script_createBullet(2 + irandom(1), x, y, _shotDir + irandom_range(-10, 10), 3);
					_shotDir += 45;
				}
			}
		}
	}
} else if(state == "attack") {
	directionFacing = dsin(current_time * 1.25);
	
	var _dir = irandom(360);
	var _dist = irandom_range(20, 125); // attack range roughly for particle spawning, not super strict obviously
	
	part_type_direction(swirlParticle, _dir + 90, _dir + 90, 6, 0);
	part_particles_create(partSys, x + dcos(_dir) * _dist, y - dsin(_dir) * _dist, swirlParticle, 1);
	
	var _hitBox = 0;
	for(var _hitBoxCheck = array_length(attackTimings) - 1; _hitBoxCheck >= 0; _hitBoxCheck--) {
		_hitBox = attackTimings[_hitBoxCheck];
		if(stateTimer > stateTimerMax * _hitBox[0][0] && stateTimer < stateTimerMax * _hitBox[0][1]) {
			if(!attackHit) { // _hitbox[1-4] = width, height, xOff, yOff
				var _hit = collision_rectangle(x - _hitBox[3] * directionFacing - _hitBox[1], y - _hitBox[4] + _hitBox[2], x - _hitBox[3] * directionFacing + _hitBox[1], y - _hitBox[4] - _hitBox[2], obj_player, false, true);
				var _hitRect = instance_create_depth(x, y, -100, obj_debugHelper); 
				_hitRect.shape = "quadRect";
				_hitRect.quadLeft = x - _hitBox[3] * directionFacing - _hitBox[1];
				_hitRect.quadRight = x - _hitBox[3] * directionFacing + _hitBox[1]; // debug that doesn't even work in this project but should show the hitboxes in theory with the other object i use in all my projects
				_hitRect.quadTop = y - _hitBox[4] + _hitBox[2];
				_hitRect.quadBottom = y - _hitBox[4] - _hitBox[2];
			
				if(instance_exists(_hit)) {
					var _hitInfo = _hitBox[5];
					_hit.takeHit(_hitInfo[0], _hitInfo[1], _dirToPlayer, _hitInfo[3]);
					attackHit = true; // WIP WIP WIP WIP WIP WIP WIP
					
					//audio_play_sound(snd_punch, 1, 0, 2);
				}
			}
		}
	}
	
	if(stateTimer <= 0) {
		setState("idle");
	}
}

if(stateTimer >= 0) {
	stateTimer--;
	//stateTimer -= delta_time / 1000; // this is if we do attack timing in ms instead of frames..
}







blockingLinksRef = 0;