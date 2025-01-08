if(!instance_exists(player)) {
	player = noone;
} else {
	var _dirToPlayer = point_direction(x, y, player.x, player.y);
	x += dcos(_dirToPlayer) * 1;
	y -= dsin(_dirToPlayer) * 1;
}

var _dir = point_direction(x, y, moveGoalX, moveGoalY);

xChange += dcos(_dir) * moveSpeed;
yChange += -dsin(_dir) * moveSpeed;

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