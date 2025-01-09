global.player = id;

state = "idle"; // idle, jump
stateTimer = 0;

HealthMax = 120;
Health = HealthMax;

hitColor = 0;
hitColorTimer = 0;

xChange = 0;
yChange = 0;

moveSpeed = .9;
speedDecay = .7;

directionToMouse = 0;

spinLastOrbId = noone;
spinLastAngleOrb = 0;

spinDist = 0;
spinCenterX = 0;
spinCenterY = 0;

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

setState = function(stateSet, stateTimerSet = infinity) {
	state = stateSet;
	stateTimer = stateTimerSet;
	
	if(stateSet == "spin") {
		spinLastOrbId = noone;
		speedDecay = .7;
		spinCenterX = mouse_x;
		spinCenterY = mouse_y;
		spinDist = point_distance(x, y, mouse_x, mouse_y);
	} else if(stateSet == "jump") {
		speedDecay = 1;
		xChange = dcos(directionToMouse) *  6.5;
		yChange = -dsin(directionToMouse) * 6.5;
	} else {
		speedDecay = .7;
	}
}