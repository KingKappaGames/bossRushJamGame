if(instance_number(obj_gameManager) > 1) {
	instance_destroy();
	exit;
}

depth = -2000;

global.gameManager = id;
global.boss = noone;

global.bossStickingOrbs = 0;
global.linksTotalThisFrame = [];

global.player = noone;

global.is_paused = false;
menu_close = false;

randomize();

global.fontPixel = font_add_sprite_ext(spr_fontMenuCustom, "abcdefghijklmnopqrstuvwxyz", true, 2);

#endregion surface / buffer stuff for floor debris and markings
global.debrisSurface = 0;
global.debrisBuffer = 0;

global.fogSurface = surface_create(1920, 1080);

debrisSaveTimer = 0;

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
		
		if(global.musicPlaying != -1) {
			if(global.musicActualPlaying != -1) {
				audio_sound_gain(global.musicActualPlaying, 0, 3000);
				global.musicPlaying = -1;
			}
		}
	} else if(state == "respawn") {
		_stateText = "Click to respawn!";
		_stateTimer = 0;
	} else if(state == "moveZone") {
		_stateText = "Go to the right to find the boat";
		_stateTimer = 0;
		
		instance_create_layer(1136, 319, "Instances", obj_boat);
	} else if(state == "sail") {
		//... nothing for sailing
	} else if(state == "intro") {
		global.player.setState("intro"); // player
		
		audio_stop_sound(global.musicActualPlaying);
		global.musicPlaying = -1;
		global.musicActualPlaying = -1;
		
		var _boss = -1;
		if(bossSummon != -1) {
			if(bossSummon == 2) {
				_boss = instance_create_layer(room_width / 2, -30, "Instances", obj_bossRoller);
			} else if(bossSummon == 0) {
				_boss = instance_create_layer(room_width / 2, -60, "Instances", obj_bossSpider);
			} else if(bossSummon == 1) {
				_boss = instance_create_layer(room_width / 2, -200, "Instances", obj_bossMantis);
			}
		} else {
			var _ind = irandom(2); // boss count
			var _bossInd = array_get([obj_bossRoller, obj_bossSpider, obj_bossMantis], _ind);
			var _bossY = array_get([-30, -60, -200], _ind);
			_boss = instance_create_layer(room_width / 2, -200, "Instances", _bossInd);
		}
		_boss.setState("intro");
	} else if(state == "prefight") {
		if(instance_exists(global.player)) {
			global.player.Health = global.player.HealthMax; // heal the player between fights
		}
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
part_system_depth(global.partUnderSys, 3001); // in front of the background barely

global.partFloorSys = part_system_create();
part_system_depth(global.partFloorSys, 2999); // in front of the background barely

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
part_type_color_mix(_dust, #887856, #503020);

global.dustLittlePart = part_type_create();
var _dustLittle = global.dustLittlePart;
part_type_shape(_dustLittle, pt_shape_square);
part_type_size(_dustLittle, .08, .12, .003, 0);
part_type_life(_dustLittle, 30, 90);
part_type_alpha2(_dustLittle, 1, 0);
part_type_direction(_dustLittle, 0, 360, 0, 0);
part_type_speed(_dustLittle, .3, 1.7, -.04, 0);
part_type_color_mix(_dustLittle, #887856, #503020);
part_type_orientation(_dustLittle, 0, 360, 0, 0, 0);
part_type_gravity(_dustLittle, .001, 140);

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
part_type_size(_quakeTrail, .1, .1, .001, 0);
part_type_color_mix(_quakeTrail, #47371a, #9e7f55);
part_type_life(_quakeTrail, 60, 150);
part_type_alpha3(_quakeTrail, 1, .3, 0);
part_type_direction(_quakeTrail, 0, 360, 0, 0);
part_type_orientation(_quakeTrail, 0, 360, 0, 0, 0);
part_type_speed(_quakeTrail, .2, .8, -.03, 0);

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

global.swordParts = part_type_create();
var _swordPart = global.swordParts;
part_type_life(_swordPart, 38, 45);
part_type_shape(_swordPart, pt_shape_square);
part_type_size(_swordPart, .11, .17, 0, 0);
part_type_orientation(_swordPart, 0, 360, 0, 10, 0);
part_type_color_mix(_swordPart, #d6d6d6, #bfbfbf); 
part_type_alpha2(_swordPart, 1, .2);

global.waveArcTrail = part_type_create();
var _waveTrail = global.waveArcTrail;
part_type_life(_waveTrail, 70, 100);
part_type_shape(_waveTrail, pt_shape_line);
part_type_size(_waveTrail, .12, .19, -.0012, 0);
part_type_speed(_waveTrail, 0, .1, -.01, 0);
part_type_direction(_waveTrail, 0, 360, 0, 30);
part_type_orientation(_waveTrail, 0, 360, 0, 10, 0);
part_type_color2(_waveTrail, #ffffbb, #dddd89); 
part_type_alpha1(_waveTrail, 1);

global.cloneBurstParts = part_type_create();
var _cloneBurstParts = global.cloneBurstParts;
part_type_life(_cloneBurstParts, 55, 82);
part_type_shape(_cloneBurstParts, pt_shape_line);
part_type_size(_cloneBurstParts, .12, .24, -.001, 0);
part_type_speed(_cloneBurstParts, 1, 5, -.04, 0);
part_type_direction(_cloneBurstParts, -10, 190, 0, 0);
part_type_orientation(_cloneBurstParts, 0, 0, 0, 0, 1);
part_type_color2(_cloneBurstParts, #ffffff, #dddddd); 
part_type_alpha1(_cloneBurstParts, 1);
part_type_gravity(_cloneBurstParts, .04, 270);
part_type_step(_cloneBurstParts, -6, global.projectileTrail);

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
var _oceanPart = global.waterPart;
part_type_sprite(_oceanPart, spr_pixelShineWater, 1, 1, 1);
part_type_size(_oceanPart,.4,.4,-.002,.1);
part_type_scale(_oceanPart,1,1);
part_type_color2(_oceanPart, c_white, c_aqua );
part_type_alpha1(_oceanPart,0.4);
part_type_speed(_oceanPart,0,0,0,0);
part_type_direction(_oceanPart,270,270,0,0);
part_type_gravity(_oceanPart,0,270);
part_type_orientation(_oceanPart,0,0,0,0,1);
part_type_blend(_oceanPart, false);
part_type_life(_oceanPart,100,200);

var _splat = part_type_create();
global.splatPart = _splat;
part_type_shape(_splat, pt_shape_disk);
part_type_size(_splat, .2, .4, -.005, 0);
part_type_life(_splat, 35, 60);
part_type_direction(_splat, 0, 360, 0, 0);
part_type_speed(_splat, .1, 1.5, 0, 0);
part_type_gravity(_splat, .01, 270);

var _splash = part_type_create();
global.splashPart = _splash;
part_type_sprite(_oceanPart, spr_pixelShineWater, 1, 0, 1);
part_type_color_mix(_oceanPart, c_white, #99dddd);
part_type_size(_splash, 3, 5, -.03, 0);
part_type_life(_splash, 20, 30);
part_type_direction(_splash, -50, 230, 0, 0);
part_type_speed(_splash, .1, .4, 0, 0);
part_type_gravity(_splash, .06, 270);

global.orbActiveParts = part_type_create();
var _orbShimmer = global.orbActiveParts;
part_type_shape(_orbShimmer, pt_shape_square);
part_type_size(_orbShimmer, .23, .35, .004, 0);
part_type_life(_orbShimmer, 40, 120);
part_type_alpha3(_orbShimmer, .8, .2, 0);
part_type_direction(_orbShimmer, 0, 360, 0, 0);
part_type_speed(_orbShimmer, .3, 1.7, -.025, 0);
part_type_color2(_orbShimmer, #ffffff, #999999);
part_type_blend(_orbShimmer, true);

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