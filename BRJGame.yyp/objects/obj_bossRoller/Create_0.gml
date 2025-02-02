event_inherited();

floorSys = global.partFloorSys;

HealthMax = 55;
Health = HealthMax;

moveSpeed = .4;
speedDecay = .8;

legPairsOnGround = 7;

updateLeg = 0;

legUpdateDistance = 17;
legStepDist = 14;
legSegLen = 15;
legPositions = array_create(14, 0);
legPositionGoals = array_create(14, 0);
legOrigins = array_create(14, 0);
legStepDistances = array_create(14, 50);

for(var _i = 0; _i < 14; _i++) { // simply don't draw legs that aren't on screen, legs are drawn in pairs up to the head, ergo clipping pairs removes "arms" of prehead legs
	legPositions[_i][1] = y;
	legPositions[_i][0] = x;
	
	legPositionGoals[_i][1] = y;
	legPositionGoals[_i][0] = x;
	
	legOrigins[_i][1] = y;
	legOrigins[_i][0] = x;
}

//the same as default?
//hit = function(damage, knockback = 0, knockbackDir = 0, immunityFrames = 0) { // WIP immunity frames do things right?
//	Health -= damage;
	
//	if(Health <= 0) {
//		die();
//	} else {
//		if(knockback != 0) {
//			xChange += dcos(knockbackDir) * knockback;
//			yChange -= dsin(knockbackDir) * knockback;
//		}
//	}
//}

//die = function() {
//	global.gameManager.setGameState("victory");
//	//play death animation
//	//clear or do other set up to level..?
//	//endGame();
//}

///@desc The state setting info specific to the boss of this kind, runs within setState that does the basic set up for all bosses (this is a basic way of doing script inheritance, not ideal but works well)
setStateCore = function(stateGoal, stateDuration = -1) {
	
	image_angle = 0;
	
	var _prevLegPairs = legPairsOnGround;
	
	directionFacing = (dirToPlayer < 270 && dirToPlayer > 90) ? -1 : 1; // face the player!
	
	if(stateGoal == "idle") {
		sprite_index = spr_rollieForwardCrawl;
		image_speed = 2;
		stateType = "idle";
		
		speedDecay = .8;
		
		legPairsOnGround = 7;
		
		if(stateTimer == -1) {
			stateTimer = 0;
			stateTimerMax = 0;
		}
	} else if(stateGoal == "spinAttack") {
		sprite_index = spr_bossAttack;
		image_speed = (60 / stateTimer) * image_number; // setting frame rate to line up with time of state, maybe don't if you need something else idk (60 is for game fps, switch to 1000 if you want ms timings, you'll have to change the code for this it's not either or)
		stateType = "attack";
		
		speedDecay = .4;
		
		attackHit = false;
		
		attackTimings = [   [[.55, .95], 54, 44, 0, -10, [10, 12, 0, 120]]  ];
	} else if(stateGoal == "rolling") {
		sprite_index = spr_rollerRoll;
		image_speed = 5;
		stateType = "attack";
		
		audio_play_sound(snd_rollerRumble, 0, 0, 2);
		
		legPairsOnGround = 0;
		
		speedDecay = 1;
		
		attackHit = false;
		
		attackTimings = [   [[.05, .95], 30, 30, 0, -8, [10, 9, 0, 120]]  ];
	} else if(stateGoal == "chargingRoll") {
		xChange = 0;
		yChange = 0;
		
		audio_play_sound(snd_rollerRoar, 0, 0, .6);
		
		speedDecay = .5;
		
		legPairsOnGround = 0;
		
		sprite_index = spr_bossCharge;
		image_speed = (60 / stateTimer) * image_number;
		stateType = "charge";
	} else if(stateGoal == "chargingBurst") {
		sprite_index = spr_rollerStand;
		
		audio_play_sound(snd_rollerRoar, 0, 0, 1);
		
		legPairsOnGround = 4;
		
		xChange = 0;
		yChange = 0;
		
		speedDecay = .5;
		
		image_speed = (60 / stateTimer) * image_number;
		stateType = "charge";
	} else if(stateGoal == "shot") {
		stateType = "shot";
		
		legPairsOnGround = 7;
	} else if(stateGoal == "dead") {
		stateType = "dead";
		
		audio_play_sound(snd_rollerRoar, 0, 0, .9);
		
		stateTimer = 50;
		stateTimerMax = 50;
	} else if(stateGoal == "intro") {
		sprite_index = spr_rollerStand;
		
		stateType = "intro";
		
		audio_play_sound(snd_diggingIntro, 0, 0, 2);
		
		image_xscale = 0;
		image_yscale = 0;
		visible = false;
		
		stateTimer = 380; // force set this here since I can't specifiy lengths anywhere else more easily. Not ideal but this isn't main game, it doesn't need to be ideal
		stateTimerMax = 380;
		
		speedDecay = 1;
		xChange = 0;
		yChange = .62;
	} else if(stateGoal == "slam") {
		stateType = "attack";
		
		speedDecay = .95;
		
		xChange += dcos(dirToPlayer) * 1.5;
		yChange += -dsin(dirToPlayer) * 1.5;
		
		legPairsOnGround = 7;
		
		attackHit = false;
		
		if(dirToPlayer > 45 && dirToPlayer < 135) {
			attackTimings = [   [[.54, .64], 34, 37, 0/*x!*/, 38, [10, 0, 0, 150]]  ];
		} else if(dirToPlayer > 225 && dirToPlayer < 315) {
			attackTimings = [   [[.54, .64], 34, 37, 0/*x!*/, -38, [10, 0, 0, 150]]  ];
		} else {
			attackTimings = [   [[.54, .64], 36, 33, -40/*x!*/, 0, [10, 0, 0, 150]]  ];
		}
	} else if(stateGoal == "follow") {
		sprite_index = spr_rollerStand;
		
		audio_play_sound(snd_rollerRoar, 0, 0, .85);
		
		stateType = "move";
		
		legPairsOnGround = 4;
		
		speedDecay = .82 + global.gameDifficultySelected * .03;
	} else if(stateGoal == "bounce") {
		sprite_index = spr_bossCharge;
		image_index = image_number;
		image_speed = -1 * (60 / stateTimer) * image_number; // reverse the frames
		
		legPairsOnGround = 0;
		
		stateType = "move";
		
		speedDecay = .6;
		
	}
	
	if(legPairsOnGround > _prevLegPairs) {
		for(var _legI = _prevLegPairs * 2; _legI < legPairsOnGround * 2; _legI++) {
			legPositions[_legI][1] = y;
			legPositions[_legI][0] = x;
	
			legPositionGoals[_legI][1] = y;
			legPositionGoals[_legI][0] = x;
	
			legOrigins[_legI][1] = y;
			legOrigins[_legI][0] = x;
		}
	}
}