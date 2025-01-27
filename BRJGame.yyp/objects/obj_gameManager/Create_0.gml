if(instance_number(obj_gameManager) > 1) {
	instance_destroy();
	exit;
}

depth = -2000;

game_set_speed(60, gamespeed_fps);

global.gameManager = id;
global.bossStickingOrbs = 0;
global.linksTotalThisFrame = [];

global.player = noone;

global.is_paused = false;
menu_close = false;
randomize();

#endregion surface / buffer stuff for floor debris and markings
global.debrisSurface = 0;
global.debrisBuffer = 0;

debrisSaveTimer = 0;
instance_create_layer(x, y, "Instances", obj_surfaceDrawer);

camWidth = camera_get_view_width(view_camera[0]);
camHeight = camera_get_view_height(view_camera[0]);
camShake = 0;

#region state stuff
gameState = "starting";
gameStateTimer = 0;

setGameState = function(state, timer = -1, titleText = 0) {
	gameState = state;
	
	if(titleText != 0) {
		gameStateText = titleText;
	} else {
		gameStateText = "";
	}
	if(timer != -1) {
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
		global.player.setState("idle");
	} else if(state == "victory") {
		bossSummon = (bossSummon + 1) % 3; // randomize future boss summon
		_stateText = "You won!";
		_stateTimer = 120;
	} else if(state == "respawn") {
		_stateText = "Click to respawn!";
		_stateTimer = 0;
	} else if(state == "moveZone") {
		_stateText = "Go to the right to find the boat";
		_stateTimer = 0;
	} else if(state == "sail") {
		//... nothing for sailing
	} else if(state == "intro") {
		global.player.setState("intro"); // player
		
		audio_stop_sound(global.musicPlaying);
		
		var _boss = -1;
		if(bossSummon != -1) {
			if(bossSummon == 0) {
				_boss = instance_create_layer(room_width / 2, -200, "Instances", obj_bossRoller);
			} else if(bossSummon == 1) {
				_boss = instance_create_layer(room_width / 2, -200, "Instances", obj_bossSpider);
			} else if(bossSummon == 2) {
				_boss = instance_create_layer(room_width / 2, -200, "Instances", obj_bossMantis);
			}
		} else {
			var _ind = irandom(2); // boss count
			var _bossInd = array_get([obj_bossRoller, obj_bossSpider, obj_bossMantis], _ind);
			_boss = instance_create_layer(room_width / 2, -200, "Instances", _bossInd);
		}
		_boss.setState("intro");
	} else if(state == "prefight") {
		
	}
	
	if(gameStateTimer != 0) {
		if(timer == -1) {
			gameStateTimer = _stateTimer; // if no time given and game state timer unset.. do i need to check game state timer?
		}
	}
	if(gameStateText == "") {
		gameStateText = _stateText;
	}
}
#endregion

#region particles
global.partSys = part_system_create();
part_system_depth(global.partSys, -1000); // at the front! I think...

global.partUnderSys = part_system_create();
part_system_depth(global.partUnderSys, 3001); // at the front! I think...

global.fluffPart = part_type_create();
var _fluff = global.fluffPart;
part_type_shape(_fluff, pt_shape_square);
part_type_size(_fluff, .2, .6, -.01, 0);
part_type_life(_fluff, 20, 75);
part_type_alpha2(_fluff, 1, 0);
part_type_direction(_fluff, 0, 360, 0, 0);
part_type_speed(_fluff, .1, 1.5, -.01, 0);

global.dustPart = part_type_create();
var _dust = global.dustPart;
part_type_shape(_dust, pt_shape_square);
part_type_size(_dust, .1, .3, .01, 0);
part_type_life(_dust, 30, 120);
part_type_alpha2(_dust, 1, 0);
part_type_direction(_dust, 0, 360, 0, 0);
part_type_speed(_dust, .3, 2.5, -.05, 0);

global.swirlParticles = part_type_create();
var _swirly = global.swirlParticles;
part_type_shape(_swirly, pt_shape_square);
part_type_size(_swirly, .4, .7, -.003, 0);
part_type_color1(_swirly, c_white);
part_type_life(_swirly, 28, 42);
part_type_alpha2(_swirly, 1, 0);
part_type_direction(_swirly, 0, 360, 0, 0);
part_type_speed(_swirly, 7, 8.5, 0, 0); // specific numbers for going around the 100ish wide attack of the one boss, changable for sure but it relates to that boss's visual width...

global.trailPlowParticles = part_type_create();
var _plow = global.trailPlowParticles;
part_type_shape(_plow, pt_shape_square);
part_type_size(_plow, .3, .5, .004, 0);
part_type_color_mix(_plow, #47371a, #9e7f55);
part_type_life(_plow, 40, 90);
part_type_alpha3(_plow, 1, .5, 0);
part_type_direction(_plow, 0, 0, 0, 0);
part_type_orientation(_plow, 0, 360, 0, 0, 0);
part_type_speed(_plow, .7, 1.2, -.03, 0);

global.quakeTrailPart = part_type_create();
var _quakeTrail = global.quakeTrailPart;
part_type_shape(_quakeTrail, pt_shape_square);
part_type_size(_quakeTrail, .1, .3, .002, 0);
part_type_color_mix(_quakeTrail, #47371a, #9e7f55);
part_type_life(_quakeTrail, 30, 70);
part_type_alpha3(_quakeTrail, 1, .4, 0);
part_type_direction(_quakeTrail, 0, 360, 0, 0);
part_type_orientation(_quakeTrail, 0, 360, 0, 0, 0);
part_type_speed(_quakeTrail, .2, 1.1, -.03, 0);
part_type_gravity(_quakeTrail, 130, .005);

global.projectileTrail = part_type_create();
var _trail = global.projectileTrail;
part_type_life(_trail, 38, 45);
part_type_shape(_trail, pt_shape_square);
part_type_size(_trail, .08, .15, -.002, 0);
part_type_speed(_trail, .1, .28, -.01, 0);
part_type_direction(_trail, 0, 360, 0, 30);
part_type_orientation(_trail, 0, 360, 0, 10, 0);
part_type_color_mix(_trail, #bbbbbb, #777777); 
part_type_alpha1(_trail, 1);

global.webLineSnap = part_type_create();
var _webLineSnap = global.webLineSnap;
part_type_life(_webLineSnap, 38, 45);
part_type_shape(_webLineSnap, pt_shape_square);
part_type_size(_webLineSnap, .07, .12, -.002, 0);
part_type_size_x(_webLineSnap, .5, .5, 0, 0);
part_type_speed(_webLineSnap, .1, .28, -.01, 0);
part_type_direction(_webLineSnap, 145, 145, 0, 0);
part_type_orientation(_webLineSnap, 0, 0, 0, 10, 0);

global.waterPart = part_type_create();
var _water = global.waterPart;
part_type_shape(_water, pt_shape_square);
part_type_size(_water, .3, .5, -.005, 0);
part_type_life(_water, 50, 75);
part_type_alpha2(_water, 1, 0);
part_type_direction(_water, 280, 290, 0, 15);
part_type_speed(_water, .9, 1.1, -.01, 0);

//
//	var createdParticle = part_type_create();
//	part_type_life(createdParticle, 50, 70);
//	part_type_shape(createdParticle, pt_shape_square);
//	part_type_size(createdParticle, .1, .2, -.003, .03);
//	part_type_speed(createdParticle, 0.2, .8, -.01, .1);
//	part_type_direction(createdParticle, 0, 360, 0, 30);
//	part_type_orientation(createdParticle, 0, 360, 0, 10, 0);
		
//	part_type_alpha2(createdParticle, 1, .4);
//	part_type_color_mix(createdParticle, merge_color(#bbbbbb, color, colorStrength), merge_color(#777777, color, colorStrength));

#endregion

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


//load sounds and fmod stuff
if(!audio_group_is_loaded(ag_Music))
{
	audio_group_load(ag_Music);
};
if(!audio_group_is_loaded(ag_SFX))
{
	audio_group_load(ag_SFX);
};

//global.fmodSys = fmod_studio_system_create();
//show_debug_message("fmod_studio_system_create: " + string(fmod_last_result()));
//fmod_studio_system_init(1024, FMOD_STUDIO_INIT.LIVEUPDATE, FMOD_INIT.NORMAL);
//show_debug_message("fmod_studio_system_init: " + string(fmod_last_result()));
//fmod_main_system = fmod_studio_system_get_core_system();

//rollerSound = fmod_studio_system_load_bank_file(fmod_path_bundle("Boss Theme 3.bank"), FMOD_STUDIO_LOAD_BANK.NORMAL);
//strings_bank_ref = fmod_studio_system_load_bank_file(fmod_path_bundle("Master.strings.bank"), FMOD_STUDIO_LOAD_BANK.NORMAL);

//show_debug_message(fmod_studio_system_get_bank_count());
//show_debug_message("$###########################################")

//event_description_ref = fmod_studio_system_get_event("event:/Boss Theme 3 Loop");
//show_debug_message("get the event: " + string(fmod_last_result()))
//event_description_instance_ref = fmod_studio_event_description_create_instance(event_description_ref);
//show_debug_message("create event desc instance? : " + string(fmod_last_result()))
//show_debug_message("created instance is valid? : " + string(fmod_studio_event_instance_is_valid()))

//show_debug_message("event valid? : " + string(fmod_studio_event_instance_is_valid(event_description_instance_ref)))

//fmod_studio_event_instance_start(event_description_instance_ref);

//show_debug_message("event valid? : " + string(fmod_studio_event_instance_is_valid(event_description_instance_ref)))

//show_debug_message("start instance event: " + string(fmod_last_result()));