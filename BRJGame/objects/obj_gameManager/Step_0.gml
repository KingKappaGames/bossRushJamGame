global.linksTotalThisFrame = [];

if(gameState == "gameOver") {
	gameStateTimer--;
	if(gameStateTimer <= 0) {
		setGameState("respawn");
	}
} else if(gameState == "respawn") {
	if(mouse_check_button_released(mb_left) || mouse_check_button_released(mb_right)) {
		setGameState("fight");
	}
} else if(gameState == "victory") {
	gameStateTimer--;
	if(gameStateTimer <= 0) {
		setGameState("respawn");
	}
} else if(gameState == "fight") {
	debrisSaveTimer--;
	if(debrisSaveTimer <= 0) {
		buffer_get_surface(global.debrisBuffer, script_getDebrisSurface(), 0);
		
		debrisSaveTimer = 600;
	}
}

//if(gameState == "fight") {
	//var _linksTotal = global.linksTotalThisFrame;
	
	
//}


camShake *= .98;

var _player = instance_nearest(room_width / 2, room_height / 2, obj_player);

var _camGoalX = ((_player.x * 5 + mouse_x) / 6) - camWidth / 2;
var _camGoalY = ((_player.y * 5 + mouse_y) / 6) - camHeight / 2;

if(_player != noone) {
	camera_set_view_pos(view_camera[0], clamp(lerp(camera_get_view_x(view_camera[0]), _camGoalX, .2) + irandom_range(-camShake, camShake), 0, room_width - camWidth), clamp(lerp(camera_get_view_y(view_camera[0]), _camGoalY, .2) + irandom_range(-camShake * .5, camShake * .5), 0, room_height - camHeight)); // loosely follow player and clamp without room bounds of camera
}

if(keyboard_check_released(ord("F"))) {
	window_set_fullscreen(!window_get_fullscreen());
}