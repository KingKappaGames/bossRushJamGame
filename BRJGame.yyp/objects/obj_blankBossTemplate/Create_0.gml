event_inherited();

HealthMax = 40;
Health = HealthMax;

moveSpeed = .5;
speedDecay = .8;

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
	if(stateGoal == "idle") {
		sprite_index = spr_rollerStand;
		image_speed = 2;
		stateType = "idle";
		
		speedDecay = .8;
		
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
		
		speedDecay = 1;
		
		attackHit = false;
		
		attackTimings = [   [[.05, .95], 30, 30, 0, -8, [10, 9, 0, 120]]  ];
	} else if(stateGoal == "chargingRoll") {
		xChange = 0;
		yChange = 0;
		
		speedDecay = .5;
		
		sprite_index = spr_bossCharge;
		image_speed = (60 / stateTimer) * image_number;
		stateType = "charge";
	}
}