global.player = id;

sys = global.partSys;
underSys = global.partUnderSys;
waterParts = global.waterPart;

fluffPart = global.fluffPart;

state = "idle"; // idle, jump, stun
stateTimer = 0;
stateTimerMax = 0; // eh

HealthMax = 30;
Health = HealthMax;
highlightHealth = HealthMax;

immunityFrames = 0;
jumpCooldown = 0;

image_index = 0;
image_blend = c_white;
hitColorTimer = 0;

healthBarFade = 0;

introGoalX = 0; // point to move to when intro is playing, set by intro state in game manager
introGoalY = 0;

xChange = 0;
yChange = 0;

moveSpeed = .7;
speedDecay = .7;

directionToMouse = 0;

spinLastOrbId = noone;
spinLastAngleOrb = 0;

orbSpawnType = 0; // fire, web, frost

spinDist = 0;
spinCenterX = 0;
spinCenterY = 0;

handDist = 58;
handX = 0;
handY = 0;

orbClickRange = 50;

orbLinkFromId = noone;

camWidth = camera_get_view_width(view_camera[0]);
camHeight = camera_get_view_height(view_camera[0]);

#region leg stuff
legUpdateDistance = 52;
legStepDist = 25;
legSegLen = 31;
legPositions = array_create(8, 0);
legPositionGoals = array_create(8, 0);
legOrigins = array_create(8, 0);

for(var _i = 0; _i < 8; _i++) {
	legPositions[_i][1] = y;
	legPositions[_i][0] = x;
	
	legPositionGoals[_i][1] = y;
	legPositionGoals[_i][0] = x;
	
	legOrigins[_i][1] = y;
	legOrigins[_i][0] = x;
}
#endregion

takeHit = function(damage, knockback = 0, hitDirection = 0, immunityFramesSet = 0) {
	if(Health > 0) {
		if(immunityFrames <= 0) { // no immunity (ergo do hits and stuff)
			audio_play_sound(snd_playerHit, 0, 0);
			
			var _damageExtraFromDifficulty = 1 - ((1 - global.gameDifficultySelected) * .25);
			Health = clamp(Health - (damage * _damageExtraFromDifficulty), 0, HealthMax); // .75, 1, 1.25 for the three difficulties
			part_particles_create_color(global.partSys, x, y, global.splatPart, #baff85, damage * _damageExtraFromDifficulty); 
		
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
	
		if(instance_exists(global.boss)) {
			if(global.boss.state == "slam") {
				setState("squish", 85);
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
}

die = function() {
	with(obj_cloneMantis) {
		die();
	}
	setState("dead");
	global.gameManager.setGameState("gameOver");
}

setState = function(stateSet, stateTimerSet = infinity) {
	if(state == "dead") { exit; } // exit immediately if the player already dead, simple solution
	state = stateSet;
	stateTimer = stateTimerSet;
	stateTimerMax = stateTimerSet;
	
	if(stateSet == "spin") {
		spinLastOrbId = noone;
		speedDecay = .7;
		spinCenterX = mouse_x;
		spinCenterY = mouse_y;
		spinDist = point_distance(x, y, mouse_x, mouse_y);
	} else if(stateSet == "jump") {
		jumpCooldown = 40;
		speedDecay = 1;
		xChange =  dcos(directionToMouse) * 6.2;
		yChange = -dsin(directionToMouse) * 6.2;
		image_angle = directionToMouse;
		
		audio_play_sound(snd_jump, 0, 0);
	} else if(stateSet == "knock") {
		speedDecay = .92;
	} else if(stateSet == "dead" || stateSet == "squish") {
		xChange = 0;
		yChange = 0;
		
		#region leg stuff
		var _legAngle = image_angle + 40;
		var _legOrigin = 0;
		var _legPos = 0;
		var _legPosGoal = 0;
		for(var _legI = 0; _legI < 8; _legI++) {
			_legPos = legPositions[_legI];
			_legPosGoal = legPositionGoals[_legI];
			_legOrigin = legOrigins[_legI];
	
			_legOrigin[0] = x + dcos(_legAngle) * 7;
			_legOrigin[1] = y - dsin(_legAngle) * 7;
	
			_legPosGoal[0] = _legOrigin[0] + dcos(_legAngle) * legStepDist * 1.8;
			_legPosGoal[1] = _legOrigin[1] - dsin(_legAngle) * legStepDist * 1.8;
	
			_legAngle += 33; // add between 40 and 140
			if(_legI == 3) {
				_legAngle += 47; // flip from left set of legs to right, these values are all hard coded so no they won't be correct if you change things. Basically though it's 4 legs between 40 and 140 counter clockwise from the head direction then add 80 to do 4 legs 220 to 320
			}
		}
		#endregion legs
		// nothing... but block other states (:
	} else if(stateSet == "sail") {
		xChange = 0;
		yChange = 0;
	} else if(stateSet == "intro") {
		xChange = 0;
		yChange = 0;
		
		introGoalX = room_width * .39;
		introGoalY = room_height * .52; // generic start position of intro
	} else {
		speedDecay = .7;
	}
}

setState("idle");