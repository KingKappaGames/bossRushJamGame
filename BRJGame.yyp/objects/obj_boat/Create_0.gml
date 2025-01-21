// placeholder
global.boat = id;

depth = 1000; // ?

active = 0;

transitionTime = 0;
transitionTimeMax = 60;

interactionRange = 80;
inRange = false;

activate = function() {
	active = 1;
	
	global.gameManager.setGameState("sail");
}