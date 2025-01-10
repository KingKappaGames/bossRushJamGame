global.boss = id;

player = global.player;

partSys = global.partSys;
swirlParticle = global.swirlParticles;

state = "idle";
stateTimer = 0;
actionTimerMax = 0;

attackTimings = []; // array of some number of hitbox entries in one attack state = [ [[timeBegin, timeEnd], width, height, xOffset, yOffset, [damage, kbStrength, kbDir, immunityFrames]] ] stores info for each current states attacks and the timings and positions / damage and knockback of each so you can do multiple hitboxes at the same time, switch, ect specifiy as many different hitboxes as you want easily and how much damage each do individually

HealthMax = 40;
Health = HealthMax;

moveSpeed = .5;
speedDecay = .8;

xChange = 0;
yChange = 0;

directionFacing = 0;
moveGoalX = 0;
moveGoalY = 0;

attackHit = false; // if the current attack has already landed on player

blockingLinksRef = 0;

hit = function(damage, knockback, knockbackDir, immunityFrames) { // ??
	Health -= damage;
	
	
	
	if(Health <= 0) {
		die();
	}
}

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

setState = function(stateGoal, stateDuration = -1) {
	state = stateGoal;
	stateTimer = stateDuration;
	stateTimerMax = stateDuration;
	
	if(stateGoal == "idle") {
		sprite_index = spr_bossIdle;
		image_speed = 2;
		
		if(stateTimer == -1) {
			stateTimer = 0;
			stateTimerMax = 0;
		}
	} else if(stateGoal == "attack") {
		sprite_index = spr_bossAttack;
		image_speed = (60 / stateTimer) * image_number; // setting frame rate to line up with time of state, maybe don't if you need something else idk (60 is for game fps, switch to 1000 if you want ms timings, you'll have to change the code for this it's not either or)
		
		attackHit = false;
		
		attackTimings = [   [[.4, .95], 66, 48, 0, -10, [15, 12, 0, 120]]  ];
	}
}

setState("idle"); // initialize at idle