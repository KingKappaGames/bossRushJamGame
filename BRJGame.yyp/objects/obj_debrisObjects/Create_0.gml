xChange = random_range(-1.8, 1.8);
yChange = random_range(-1.3, 1.3);
currentDirection = point_direction(0, 0, xChange, yChange);
currentSpeed = point_distance(0, 0, xChange, yChange);

duration = 240;
flightHeight = 11;
heightChange = random_range(0, 1.25);
grav = -.035;

drawNextFrame = false;

imageSpin = random_range(-3, 3);

hitGround = function(blocked = false) {
	flying = false;
	
	var _speed = point_distance(0, 0, xChange, yChange);
	
	if(_speed < .15) {
		drawNextFrame = true;
	}
	
	
	xChange = dcos(currentDirection + irandom_range(-30, 30)) * _speed * .4;
	yChange = -dsin(currentDirection + irandom_range(-30, 30)) * _speed * .4;

	
	if(_speed > .8) {
		if(irandom(2) == 0) {
			audio_play_sound(snd_shotHit, 0, 0);
		}
	}
	
	heightChange = .45 * (.55 + _speed / 4);
}