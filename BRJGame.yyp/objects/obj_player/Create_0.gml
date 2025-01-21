global.player = id;

underSys = global.partUnderSys;
waterParts = global.waterPart;

state = "idle"; // idle, jump, stun
stateTimer = 0;

HealthMax = 30;
Health = HealthMax;

immunityFrames = 0;

image_blend = c_white;
hitColorTimer = 0;

xChange = 0;
yChange = 0;

directionFacing = 0;
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

takeHit = function(damage, knockback = 0, hitDirection = 0, immunityFramesSet = 0) {
	if(immunityFrames <= 0) { // no immunity (ergo do hits and stuff)
		Health -= damage;
		
		if(damage > 2) {
			script_cameraShake(damage * (damage / 2));
		}
		
		immunityFrames = immunityFramesSet;
	
		image_blend = c_red;
		hitColorTimer = 20;
	
		if(Health <= 0) {
			die();
		}
	}
	
	if(knockback != 0) {
		xChange += dcos(hitDirection) * knockback;
		yChange -= dsin(hitDirection) * knockback;
		
		if(knockback > 7) {
			setState("knock", 55);
		}
	}
}

die = function() {
	setState("dead");
	global.gameManager.setGameState("gameOver");
}

setState = function(stateSet, stateTimerSet = infinity) {
	if(state == "dead") { exit; } // exit immediately if the player already dead, simple solution
	state = stateSet;
	stateTimer = stateTimerSet;
	
	if(stateSet == "spin") {
		image_speed = 20; // oh lawd he skittering ff
		spinLastOrbId = noone;
		speedDecay = .7;
		spinCenterX = mouse_x;
		spinCenterY = mouse_y;
		spinDist = point_distance(x, y, mouse_x, mouse_y);
	} else if(stateSet == "jump") {
		image_speed = 0;
		speedDecay = 1;
		xChange =  dcos(directionToMouse) * 6.5;
		yChange = -dsin(directionToMouse) * 6.5;
		directionFacing = directionToMouse;
	} else if(stateSet == "knock") {
		speedDecay = .92;
		image_speed = 0;
	} else if(stateSet == "dead") {
		// nothing... but block other states (:
	} else if(stateSet == "sail") {
		xChange = 0;
		yChange = 0;
		image_speed = 0;
		image_angle = 270;
	} else {
		image_speed = 12;
		speedDecay = .7;
	}
}

setState("idle");