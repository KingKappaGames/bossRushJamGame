global.boss = id;

player = global.player;

HealthMax = 40;
Health = HealthMax;

moveSpeed = .5;
speedDecay = .8;

xChange = 0;
yChange = 0;

moveGoalX = 0;
moveGoalY = 0;

hit = function(damage) {
	Health -= damage;
	if(Health <= 0) {
		die();
	}
}

die = function() {
	global.gameManager.setGameState("victory");
	//play death animation
	//clear or do other set up to level..?
	//endGame();
}