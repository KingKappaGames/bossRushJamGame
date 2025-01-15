global.boss = id;

player = global.player;

partSys = global.partSys;
swirlParticle = global.swirlParticles;
fluffParticle = global.fluffPart;
plowParticle = global.trailPlowParticles;

state = "idle";
stateType = "idle";
stateTimer = 0;
actionTimerMax = 0;

attackTimings = []; // array of some number of hitbox entries in one attack state = [ [[timeBegin, timeEnd], width, height, xOffset, yOffset, [damage, kbStrength, kbDir, immunityFrames]] ] stores info for each current states attacks and the timings and positions / damage and knockback of each so you can do multiple hitboxes at the same time, switch, ect specifiy as many different hitboxes as you want easily and how much damage each do individually

HealthMax = 40;
Health = HealthMax;

moveSpeed = .5;
speedDecay = .8;

xChange = 0;
yChange = 0;

dirToPlayer = 0;
directionFacing = 0;
moveGoalX = 0;
moveGoalY = 0;

attackHit = false; // if the current attack has already landed on player

blockingLinksRef = 0;

hit = function(damage, knockback = 0, knockbackDir = 0, immunityFrames = 0) { // WIP immunity frames do things right?
	Health -= damage;
	
	if(Health <= 0) {
		die();
	} else {
		if(knockback != 0) {
			xChange += dcos(knockbackDir) * knockback;
			yChange -= dsin(knockbackDir) * knockback;
		}
	}
}

die = function() {
	global.gameManager.setGameState("victory");
	//play death animation
	//clear or do other set up to level..?
	//endGame();
}

///@desc The state setting info specific to the boss of this kind, runs within setState that does the basic set up for all bosses (this is a basic way of doing script inheritance, not ideal but works well)
setStateCore = function(stateGoal, stateDuration) {
	//what does the specific boss do? (Not in here, this is the parent object!)
}


setState = function(stateGoal, stateDuration = -1) {
	state = stateGoal;
	stateTimer = stateDuration;
	stateTimerMax = stateDuration;
	
	image_angle = 0;
	
	setStateCore(stateGoal, stateDuration);
	
	image_index = 0;
}