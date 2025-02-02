timer += timerSpeed;
height = dsin(timer);

if(timer >= 180) {
	instance_destroy();
} else if(timer > 90) {
	timerSpeed = 1.8;
	
	if(!hitAlready) {
		hitAlready = true;
		var _player = global.player;
		if(instance_exists(global.player)) {
			if(point_distance(x, y, _player.x, _player.y) < 20) {
				_player.takeHit(4, 3, point_direction(x, y, _player.x, _player.y), 30);
			}
		}
	}
}