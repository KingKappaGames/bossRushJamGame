global.player = id;

HealthMax = 12;
Health = HealthMax;

hitColor = 0;
hitColorTimer = 0;

xChange = 0;
yChange = 0;

moveSpeed = .85;
speedDecay = .8;

handDist = 50;

orbClickRange = 50;

orbLinkFromId = noone;

camWidth = camera_get_view_width(view_camera[0]);
camHeight = camera_get_view_height(view_camera[0]);

takeHit = function(damage, directionHit) {
	Health -= damage;
	
	xChange += dcos(directionHit) * (damage / 2);
	yChange -= dsin(directionHit) * (damage / 2);
	
	hitColor = c_red;
	hitColorTimer = 20;
	
	if(Health <= 0) {
		die();
	}
}

die = function() {
	global.gameManager.setGameState("gameOver");
}