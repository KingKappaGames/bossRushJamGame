if(!instance_exists(player)) {
	player = noone;
} else {
	var _dirToPlayer = point_direction(x, y, player.x, player.y);
	x += dcos(_dirToPlayer) * 1;
	y -= dsin(_dirToPlayer) * 1;
}

var _dir = point_direction(x, y, moveGoalX, moveGoalY);

xChange += dcos(_dir) * moveSpeed  * (1 - clamp(global.bossStickingOrbs / 10, 0, 1));
yChange += -dsin(_dir) * moveSpeed * (1 - clamp(global.bossStickingOrbs / 10, 0, 1));

if(blockingLinksRef != 0) {
	for(var _i = array_length(blockingLinksRef) - 1; _i >= 0; _i--) {
		var _orbPair = blockingLinksRef[_i];
		if(_orbPair[0].fakeOrb == false && _orbPair[1].fakeOrb == false) {
			if(script_checkLineIntersectsLine(_orbPair[0].x, _orbPair[0].y, _orbPair[1].x, _orbPair[1].y, x - xChange * 2, y - yChange * 2, x + xChange * 2, y + yChange * 2, true)) { // check all web links for collision with this boss and create fake collision point if so
				script_createWebStuckPoint(id, _orbPair); // blocking links is a sub array of both orbs in the link, perfect for this
			}
		}
	}
}

x = clamp(x + xChange, 0, room_width);
y = clamp(y + yChange, 0, room_height);

xChange *= speedDecay;
yChange *= speedDecay;

var _goalDist = point_distance(x, y, moveGoalX, moveGoalY);
if(_goalDist < 50) {
	moveGoalX = irandom(room_width);
	moveGoalY = irandom(room_height);
}

if(player != noone) {
	var _playerDist = point_distance(x, y, player.x, player.y);
	if(_playerDist < 200) {
		if(irandom(30) == 0) {
			var _shotDir = point_direction(x, y, player.x, player.y);
			script_createBullet(1 + irandom(2), x, y, _shotDir, 3);
		}
	}
}

blockingLinksRef = 0;