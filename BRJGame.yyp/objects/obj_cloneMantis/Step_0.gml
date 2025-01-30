depth = -y; // el classico, que quapo

if(!instance_exists(player)) {
	player = noone;
} else {
	dirToPlayer = point_direction(x, y, player.x, player.y);
}

if(player != noone) {
	if(blockingLinksRef != 0) { // get web blocks
		for(var _i = array_length(blockingLinksRef) - 1; _i >= 0; _i--) {
			var _orbPair = blockingLinksRef[_i];
			if(_orbPair[0].fakeOrb == false && _orbPair[1].fakeOrb == false) {
				if(script_checkLineIntersectsLine(_orbPair[0].x, _orbPair[0].y, _orbPair[1].x, _orbPair[1].y, x - xChange * 2, y - yChange * 2, x + xChange * 2, y + yChange * 2, true) != 0) { // check all web links for collision with this boss and create fake collision point if so
					die(); // dissapate when hit by web
				}
			}
		}
	}
}

x = clamp(x + xChange, 15, room_width - 15);
y = clamp(y + yChange, 40, room_height - 40);


xChange *= speedDecay;
yChange *= speedDecay;

if(stateTimer >= 0) {
	stateTimer--;
}

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

if(state == "slashBasic") {
	x = lerp(x, player.x, .02);
	y = lerp(y, player.y, .02); // lock tf on
		
	if(point_distance(x, y, player.x, player.y) < 27) {
		x = player.x - dcos(dirToPlayer) * 27;
		y = player.y + dsin(dirToPlayer) * 27;
	}
	
	script_doHitboxCollisionsAndDamage();
	
	if(stateTimer <= 0) {
		die();
	}
} else if(state == "chase") {
	var _speedMultFromDifficulty = array_get([.8, .99, 1.05], global.gameDifficultySelected); // get speeds from difficulty selection, that being said, the speed is very close to being too much so 1.03 is harder than 1 while .85 is quite easy
		 
	xChange += dcos(dirToPlayer) * moveSpeed * 1 * _speedMultFromDifficulty;
	yChange -= dsin(dirToPlayer) * moveSpeed * 1 * _speedMultFromDifficulty;
		
	if(point_distance(x, y, player.x, player.y) < 45) {
		setState("slashBasic", 50);
	}
}

#region leg stuff
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

#endregion