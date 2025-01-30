event_inherited();

headFacing = 1;

HealthMax = 40;
Health = HealthMax;

moveSpeed = .3;
speedDecay = .8;

legUpdateDistance = 35;
legStepDist = 18;
legSegLen = 26;
legPositions = array_create(4, 0);
legPositionGoals = array_create(4, 0);
legOrigins = array_create(4, 0);
legStepDistances = array_create(4, 30);

strafeDir = 1;

armSprite = -1;
armSwingStartTime = 0;
armSwingEndTime = 0;

backArmSwingAngle = 0;
frontArmSwingAngle = 0;

for(var _i = 0; _i < 4; _i++) {
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
	
	if(stateGoal == "idle") {
		stateType = "idle";
		
		speedDecay = .8;
		
		if(stateTimer == -1) {
			stateTimer = 0;
			stateTimerMax = 0;
		}
	} else if(stateGoal == "spinAttack") {
		stateType = "attack";
		
		speedDecay = .4;
		
		attackHit = false;
		
		attackTimings = [   [[.55, .95], 54, 44, 0, -10, [10, 12, 0, 120]]  ];
	} else if(stateGoal == "rolling") {
		stateType = "attack";
		
		speedDecay = 1;
		
		attackHit = false;
		
		attackTimings = [   [[.05, .95], 30, 30, 0, -8, [10, 9, 0, 120]]  ];
	} else if(stateGoal == "chargingRoll") {
		xChange = 0;
		yChange = 0;
		
		speedDecay = .5;
		
		stateType = "charge";
	} else if(stateGoal == "chargeCast") {
		xChange = 0;
		yChange = 0;
		
		speedDecay = .5;
		
		stateType = "charge";
	} else if(stateGoal == "cast") {
		directionFacing = 1;
		if(dirToPlayer > 90 && dirToPlayer < 270) {
			directionFacing = -1;
		}
		
		stateType = "cast";
		
		backArmSwingAngle = 0;
		backArmSwingAngle = 0;
	} else if(stateGoal == "dead") {
		stateType = "dead";
		
	} else if(stateGoal == "intro") {
		stateType = "intro";
		
		stateTimer = 360; // force set this here since I can't specifiy lengths anywhere else more easily. Not ideal but this isn't main game, it doesn't need to be ideal
		stateTimerMax = 360;
		
		speedDecay = 0;
		xChange = 0;
		yChange = 0;
	} else if(stateGoal == "slashBasic") {
		directionFacing = 1;
		if(dirToPlayer > 90 && dirToPlayer < 270) {
			directionFacing = -1;
		}
		
		armSwingStartTime = current_time + 300;
		armSwingEndTime = current_time + 800;
		
		stateType = "attack";
		
		speedDecay = .85;
		
		xChange = dcos(dirToPlayer) * 2.5;
		yChange = -dsin(dirToPlayer) * 2.5;
		
		attackHit = false;
		
		attackTimings = [   [[.25, .35], 30, 30, -40, 0, [8, 0, 0, 75]]  ];
	} else if(stateGoal == "chase") {
		stateType = "move";
		
		xChange = dcos(dirToPlayer) * moveSpeed * 2.5;
		yChange = -dsin(dirToPlayer) * moveSpeed * 2.5;
		
		speedDecay = .85;
	} else if(stateGoal == "teleport") {
		stateType = "teleport";
		
		var _beamFrom = instance_create_layer(xprevious, yprevious, "Instances", obj_LightBeamEffect);
		_beamFrom.augmentEffect(43, 4.2, c_white, .65);
		
		var _beamTo = instance_create_layer(x, y, "Instances", obj_LightBeamEffect);
		_beamTo.augmentEffect(50, 3.1, c_white, .8);
	} else if(stateGoal == "strafe") { // move around player
		stateType = "move";
		
		speedDecay = .95;
	}
}

spawnClone = function(xx, yy, circleSpawn = false) {
	if(circleSpawn) {
		var _dir = irandom(360) div 45 * 45; // spawn along 8 axis cardinals ect ect
		
		xx = room_width / 2 + dcos(_dir) * room_width * .3;
		yy = room_height / 2 - dsin(_dir) * room_height * .3;
	}
	
	instance_create_layer(xx, yy, "Instances", obj_cloneMantis);
	var _beamTo = instance_create_layer(xx, yy, "Instances", obj_LightBeamEffect);
	_beamTo.augmentEffect(50, 3.1, c_white, .8);
}