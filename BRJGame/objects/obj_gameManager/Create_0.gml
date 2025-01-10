depth = 2000;

global.gameManager = id;
global.bossStickingOrbs = 0;
global.linksTotalThisFrame = [];

randomize();

#endregion surface / buffer stuff for floor debris and markings
global.debrisSurface = surface_create(room_width, room_height);
global.debrisBuffer = buffer_create(room_width * room_height * 4, buffer_fixed, 1);

debrisSaveTimer = 300;

camWidth = camera_get_view_width(view_camera[0]);
camHeight = camera_get_view_height(view_camera[0]);
camShake = 0;

#region state stuff
gameState = "starting";
gameStateTimer = 0;

setGameState = function(state, timer = -1, titleText = 0) {
	gameState = state;
	
	instance_destroy(obj_boss);
	instance_destroy(obj_player);
	
	if(titleText != 0) {
		gameStateText = titleText;
	} else {
		gameStateText = "";
	}
	if(timer == -1) {
		gameStateTimer = timer; // establishing default values for non set states
	} else {
		gameStateTimer = 0;
	}
	
	var _stateText = ""; // setting hold variables for generic sets
	var _stateTimer = 0;
	
	if(state == "gameOver") {
		_stateText = "You died!";
		_stateTimer = 120;
	} else if(state == "fight") {
		instance_create_layer(200, 400, "Instances", obj_player);

		instance_create_layer(300, 400, "Instances", obj_boss);
	} else if(state == "victory") {
		_stateText = "You won!";
		_stateTimer = 120;
	} else if(state == "respawn") {
		_stateText = "Click to respawn!";
		_stateTimer = 0;
	}
	
	if(gameStateTimer != 0) {
		gameStateTimer = _stateTimer;
	}
	if(gameStateText == "") {
		gameStateText = _stateText;
	}
}
#endregion

#region particles
global.partSys = part_system_create();
part_system_depth(global.partSys, -1000); // at the front! I think...

global.fluffPart = part_type_create();
var _fluff = global.fluffPart;
part_type_shape(_fluff, pt_shape_square);
part_type_size(_fluff, .3, 1, -.01, 0);
part_type_color1(_fluff, c_yellow);
part_type_life(_fluff, 20, 75);
part_type_alpha2(_fluff, 1, 0);
part_type_direction(_fluff, 0, 360, 0, 0);
part_type_speed(_fluff, .1, 1.5, -.01, 0);

global.swirlParticles = part_type_create();
var _swirly = global.swirlParticles;
part_type_shape(_swirly, pt_shape_square);
part_type_size(_swirly, .4, .7, -.003, 0);
part_type_color1(_swirly, c_white);
part_type_life(_swirly, 28, 42);
part_type_alpha2(_swirly, 1, 0);
part_type_direction(_swirly, 0, 360, 0, 0);
part_type_speed(_swirly, 7, 8.5, 0, 0); // specific numbers for going around the 100ish wide attack of the one boss, changable for sure but it relates to that boss's visual width...

#endregion

instance_create_layer(200, 400, "Instances", obj_player);
instance_create_layer(400, 400, "Instances", obj_boss);

//var _x = -200;
//var _y = -200;

//repeat(40) {
//	repeat(40) {
//		instance_create_layer(400 + _x, 400 + _y, "Instances", obj_boss);
//		_x += 10;
//	}
//	_x = -200;
//	_y += 10;
//}