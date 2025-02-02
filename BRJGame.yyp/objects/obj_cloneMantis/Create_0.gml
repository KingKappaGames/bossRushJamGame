player = global.player;

partSys = global.partSys;

cloneBurstParts = global.cloneBurstParts;
fluff = global.fluffPart;
swordTrail = global.swordParts;

state = "idle";
stateType = "idle";
stateTimer = 0;
actionTimerMax = 0;

attackTimings = []; // array of some number of hitbox entries in one attack state = [ [[timeBegin, timeEnd], width, height, xOffset, yOffset, [damage, kbStrength, kbDir, immunityFrames]] ] stores info for each current states attacks and the timings and positions / damage and knockback of each so you can do multiple hitboxes at the same time, switch, ect specifiy as many different hitboxes as you want easily and how much damage each do individually

moveSpeed = .5;
speedDecay = .8;

xChange = 0;
yChange = 0;

dirToPlayer = 0;
directionFacing = 1;

attackHit = false; // if the current attack has already landed on player

blockingLinksRef = 0;

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

armSwingStartTime = 0;
armSwingEndTime = 0;

partSwingDir = 0;
partSwingX = 0;
partSwingY = 0;
partJumpAngle = 0;
extraMoveUsed = false;

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
hit = function(damage, knockback = 0, knockbackDir = 0, immunityFrames = 0) {
	die();
}

die = function() {
	
	repeat(30) {
		part_particles_create(partSys, x + 8 * directionFacing + irandom_range(-15, 15), y - 8 + irandom_range(-15, 15), cloneBurstParts, 1);
		part_particles_create(partSys, x + 8 * directionFacing + irandom_range(-15, 15), y - 8 + irandom_range(-15, 15), fluff, 1);
	}
	instance_destroy();
	//play death animation
	//clear or do other set up to level..?
	//endGame();
}

setState = function(stateGoal, stateDuration = -1) {
	state = stateGoal;
	stateTimer = stateDuration;
	stateTimerMax = stateDuration;
	
	directionFacing = sign(directionFacing); 
	
	setStateCore(stateGoal, stateDuration);
	
	image_index = 0; 
}

///@desc The state setting info specific to the boss of this kind, runs within setState that does the basic set up for all bosses (this is a basic way of doing script inheritance, not ideal but works well)
setStateCore = function(stateGoal, stateDuration = -1) {
	if(stateGoal == "chase") {
		xChange = dcos(dirToPlayer) * moveSpeed * 2.5;
		yChange = -dsin(dirToPlayer) * moveSpeed * 2.5;
		
		speedDecay = .85;
	} else if(stateGoal == "slashBasic") {
		directionFacing = (dirToPlayer < 270 && dirToPlayer > 90) ? -1 : 1; // face the player!
		
		partSwingDir = dirToPlayer + 200;
		partSwingX = x + dcos(dirToPlayer) * -18;
		partSwingY = y - dsin(dirToPlayer) * -18;
		
		stateType = "attack";
		
		speedDecay = .92;
		
		attackHit = false;
		extraMoveUsed = false;
		
		attackTimings = [   [[.14, .22], 26, 26, abs(dcos(dirToPlayer)) * -40, dsin(dirToPlayer) * 40, [8, 0, 0, 75]]  ]; // place hitbox towards swing
	}
}

setState("chase", 180);

audio_play_sound(snd_cloneSummon, 0, 0);