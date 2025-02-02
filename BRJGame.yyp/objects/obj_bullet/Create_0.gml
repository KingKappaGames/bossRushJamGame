sys = global.partSys;

trail = global.projectileTrail;
dust = global.dustPart;
dustLittle = global.dustLittlePart;

hostile = true; // to check whether it's hitting boss or player?

currentDirection = 0;
currentSpeed = 0;
xChange = 0;
yChange = 0;

damage = 1;
hitRadius = 12;

flying = true; // whether this projectile is still active and can hurt things
duration = 180;
flightHeight = 11;
heightChange = -.11;
grav = -.04;

drawNextFrame = false;

image_blend = merge_color(#47371a, #9e7f55, random(1)); 
imageSpin = random_range(-10, 10);

hitGround = function(blocked = false) {
	flying = false;
	
	var _speed = point_distance(0, 0, xChange, yChange);
	
	if(_speed < .15) {
		drawNextFrame = true;
	}
	
	if(blocked) {
		xChange = dcos(currentDirection + irandom_range(90, 270)) * _speed / 3;
		yChange = -dsin(currentDirection + irandom_range(90, 270)) * _speed / 3;
	} else {
		xChange = dcos(currentDirection + irandom_range(-30, 30)) * _speed / 3;
		yChange = -dsin(currentDirection + irandom_range(-30, 30)) * _speed / 3;
	}
	
	if(object_index == obj_bullet) {
		if(_speed > .8) {
			part_particles_create(sys, x, y, dustLittle, irandom_range(4, 12));
			audio_play_sound(choose(snd_shotHit, snd_shotHit2), 0, 0);
		}
	}
	
	heightChange = .4 * (.5 + _speed / 3);
}

hit = function() {	
	hitGround(true);
}