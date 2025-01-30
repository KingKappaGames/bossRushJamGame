event_inherited();

HealthMax = 40;
Health = HealthMax;

moveSpeed = .5;
speedDecay = .8;

legUpdateDistance = 62;
legStepDist = 44;
legSegLen = 56;
legPositions = array_create(8, 0);
legPositionGoals = array_create(8, 0);
legOrigins = array_create(8, 0);
legStepDistances = array_create(8, 50);

strafeDir = 1;

for(var _i = 0; _i < 8; _i++) {
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


/*
The spider will have these ai states, walking to a specific (non player) position
strafing / spacing with the player (this is similar to main game ai)
charging in / going for a bite (strict advance towards player for a sustained period)
spawning spells / weaving? I don't think the weaving will be the same kind of line collisions as the player but rather damaging areas or line intersection dangers


*/


///@desc The state setting info specific to the boss of this kind, runs within setState that does the basic set up for all bosses (this is a basic way of doing script inheritance, not ideal but works well)
setStateCore = function(stateGoal, stateDuration = -1) {
	directionFacing = 1;
	
	if(stateGoal == "idle") { // idle means 
		//sprite_index = spr_bossIdle;
		stateType = "idle";
		
		speedDecay = .8;
		
		if(stateTimer == -1) {
			stateTimer = 0;
			stateTimerMax = 0;
		}
	} else if(stateGoal == "strafe") { // move around player
		stateType = "move";
		
		speedDecay = .95;
	} else if(stateGoal == "bite") { // land a bite on the player, this locks both parties in place (after they contact)
		stateType = "attack";
		
		speedDecay = .7;
		
		attackHit = false;
		attackTimings = [   [[.6, .95], 60, 60, 0, -8, [15, 0, 0, 120]]  ]; // bite (generalized attack for something that should be guaranteed..)
	} else if(stateGoal == "chase") { // charge towards player and land bite when close
		stateType = "move";
		
		speedDecay = .88;
	} else if(stateGoal == "chargeCast") {
		xChange = 0;
		yChange = 0;
		
		speedDecay = .5;
		
		//sprite_index = spr_bossCharge;
		//image_speed = (60 / stateTimer) * image_number;
		
		stateType = "charge";
	} else if(stateGoal == "cast") {
		speedDecay = .5;
		
		stateType = "cast";
	} else if(stateGoal == "dead") {
		stateType = "dead";
		
		xChange = 0;
		yChange = 0;
		
		var _legAngle = image_angle + 40;
		var _legOrigin = 0;
		var _legPos = 0;
		var _legPosGoal = 0;
		for(var _legI = 0; _legI < 8; _legI++) {
			_legPos = legPositions[_legI];
			_legPosGoal = legPositionGoals[_legI];
			_legOrigin = legOrigins[_legI];
	
			_legOrigin[0] = x + dcos(_legAngle) * 17;
			_legOrigin[1] = y - dsin(_legAngle) * 17;
	
			_legPosGoal[0] = _legOrigin[0] + dcos(_legAngle) * legStepDist * 2.4;
			_legPosGoal[1] = _legOrigin[1] - dsin(_legAngle) * legStepDist * 2.4;
	
			_legAngle += 33; // add between 40 and 140
			if(_legI == 3) {
				_legAngle += 47; // flip from left set of legs to right, these values are all hard coded so no they won't be correct if you change things. Basically though it's 4 legs between 40 and 140 counter clockwise from the head direction then add 80 to do 4 legs 220 to 320
			}
		}
		
		part_particles_create(global.partSys, x, y, global.fluffPart, 50);
	} else if(stateGoal == "intro") {
		image_angle = 270;
		
		stateType = "move";
		
		stateTimer = 320; // force set this here since I can't specifiy lengths anywhere else more easily. Not ideal but this isn't main game, it doesn't need to be ideal
		stateTimerMax = 320;
		
		speedDecay = 1;
		xChange = 0;
		yChange = .9;
	}
	
	//attackHit = false;
	//attackTimings = [   [[.05, .95], 30, 30, 0, -8, [10, 9, 0, 120]]  ];
}