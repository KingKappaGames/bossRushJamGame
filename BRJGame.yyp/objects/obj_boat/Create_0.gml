// placeholder
global.boat = id;

depth = 1000; // ?

active = 0;

transitionTime = 0;
transitionTimeMax = 60;

interactionRange = 80;
inRange = false;

prevX = x;
prevY = y; // when using the paths the previous x and y don't get set until after or something so the differences don't show up

activate = function() {
	active = 1740; // total time of paths to next area
	
	path_start(path_riverRaftingExit, .9, path_action_stop, true);
	
	global.gameManager.setGameState("sail");
}