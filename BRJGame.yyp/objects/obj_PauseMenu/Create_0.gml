draw_set_font(fnt_menu);

menuWidth = 300;
menuHeight = 240;

options[0][0] = "START GAME";
options[0][1] = "OPTIONS";
options[0][2] = "CREDITS";
options[0][3] = "EXIT";

options[1][0] = "RETURN";
options[1][1] = "SOUND SETTINGS";
options[1][2] = "VISUAL SETTINGS";
options[1][3] = "GAME SETTINGS";
options[1][4] = "CONTROLS";

options[2][0] = "RETURN";
options[2][1] = "EFFECT VOLUME";
options[2][2] = "MUSIC VOLUME";

options[3][0] = "RETURN";
options[3][1] = "RESOLUTION";
options[3][2] = "FULLSCREEN";

options[4][0] = "RETURN";

options[5][0] = "RETURN";
options[5][1] = "DIFFICULTY";
options[5][2] = "VIEW SHAKE";

optionPosition = 0;
optionGroup = 0;
optionAmount = 4;

optionHeight = 105;
menuBorder = 60;
menuAlign = fa_right;

mouseSelecting = false;

#region options
//game settings
global.gameDifficultySelected = 1;
global.gameScreenShakeSelected = 2;
global.gameWindowResolutionSelected = 2;
global.gameFullscreenSelected = 0;

global.gameEffectVolume = 5;
global.gameMusicVolume = 5;

global.boss_selected = 0;
#endregion 

x = room_width / 2 - menuWidth / 2;
y = room_height / 2 - menuHeight / 2;

//game settings in menu
gameDifficultyDisplayOptions = ["POLITE", "EVERYMAN", "CHAMPION"];
gameDifficultySelected = global.gameDifficultySelected;

gameScreenShakeDisplayOptions = ["NONE", "MINIMAL", "DEFAULT", "JITTERY", "MISTAKES"];
gameScreenShakeSelected = global.gameScreenShakeSelected;

gameWindowResolutionSelected = global.gameWindowResolutionSelected;
gameWindowResolutionOptions = [[480, 270], [1280, 720], [1920, 1080], [2560, 1440]];

gameFullscreenSelected = global.gameFullscreenSelected;
gameFullscreenOptions = [false, true];
gameFullscreenDisplayOptions = ["WINDOWED", "FULLSCREEN"];

gameEffectVolume = global.gameEffectVolume;
gameMusicVolume = global.gameMusicVolume;

wheelAngle = 0;
wheelMembers = [0, 1, 2];
wheelSprites = [spr_temp_boss_1, spr_temp_boss_2, spr_temp_boss_3];

wheelCenterX = x - 150;
wheelCenterY = y + 140;
wheelWidth = 110;

#region initialize menu
initializeMenu = function(){
	window_set_size(gameWindowResolutionOptions[gameWindowResolutionSelected][0], gameWindowResolutionOptions[gameWindowResolutionSelected][1]);
	window_center();
			
	audio_group_set_gain(ag_SFX, gameEffectVolume / 10, 0);
	audio_group_set_gain(ag_Music, gameMusicVolume / 10, 0);
}
#endregion

#region menu change field
menuChangeField = function(fieldChange){
	if(fieldChange != 0) {
		audio_play_sound(snd_menuBeep, 100, false, .5);
		if(optionGroup == 2) {
			if(optionPosition == 1) {
				gameEffectVolume = clamp(gameEffectVolume + fieldChange, 0, 10);
				audio_group_set_gain(ag_SFX, gameEffectVolume / 10, 0);
			} else if(optionPosition == 2) {
				gameMusicVolume = clamp(gameMusicVolume + fieldChange, 0, 10);
				audio_group_set_gain(ag_Music, gameMusicVolume / 10, 0);
			}
		} else if(optionGroup == 3) {
			if(optionPosition == 1) {
				//change resolution
				gameWindowResolutionSelected = clamp(gameWindowResolutionSelected + fieldChange, 0, 3);
				window_set_size(gameWindowResolutionOptions[gameWindowResolutionSelected][0], gameWindowResolutionOptions[gameWindowResolutionSelected][1]);
				window_center();
			} else if(optionPosition == 2) {
				//change window configuration
				gameFullscreenSelected = clamp(gameFullscreenSelected + fieldChange, 0, 1);
				window_set_fullscreen(gameFullscreenOptions[gameFullscreenSelected]);
			}
		} else if(optionGroup == 5) {
			if(optionPosition == 1) {
				gameDifficultySelected = clamp(gameDifficultySelected + fieldChange, 0, 2);
			} else if(optionPosition == 2) {
				gameScreenShakeSelected = clamp(gameScreenShakeSelected + fieldChange, 0, 4);
			}
		} // so on for more option groups
	}
}
#endregion

#region menu select option
menuSelectOption = function(){
	if(optionGroup == 0) {
		if(optionPosition == 0) {
			audio_play_sound(snd_menuBeep, 100, false);
			//load game!
			room_goto(rm_grassyArena);
			global.gameManager.bossSummon = global.boss_selected;
		} else if(optionPosition == 1) {
			menuSwitchOptionGroup(1);
		} else if(optionPosition == 2) {
			audio_play_sound(snd_menuBeep, 100, false);
			//room_goto(rm_credits);
		} else if(optionPosition == 3) {
			game_end();
		}
	} else if(optionGroup == 1) {
		if(optionPosition == 0) {
			menuSwitchOptionGroup(0);
		} else if(optionPosition == 1) {
			menuSwitchOptionGroup(2, 1);
		} else if(optionPosition == 2) {
			menuSwitchOptionGroup(3, 1);
		} else if(optionPosition == 3) {
			menuSwitchOptionGroup(5, 1);
		} else if(optionPosition == 4) {
			menuSwitchOptionGroup(4, 1);
		}
	} else if(optionGroup == 2) {
		if(optionPosition == 0) {
			menuSwitchOptionGroup(1);
		} else if(optionPosition == 1) {
			audio_play_sound(snd_menuBlip, 100, false);
		} else if(optionPosition == 2) {
			audio_play_sound(snd_menuBlip, 100, false);
		} else if(optionPosition == 3) {
			audio_play_sound(snd_menuBlip, 100, false);
		} else if(optionPosition == 4) {
			audio_play_sound(snd_menuBlip, 100, false);
		}
	} else if(optionGroup == 3) {
		if(optionPosition == 0) {
			menuSwitchOptionGroup(1);
		} else if(optionPosition == 1) {
			audio_play_sound(snd_menuBlip, 100, false);
		} else if(optionPosition == 2) {
			audio_play_sound(snd_menuBlip, 100, false);
		} else if(optionPosition == 3) {
			audio_play_sound(snd_menuBlip, 100, false);
		} else if(optionPosition == 4) {
			audio_play_sound(snd_menuBlip, 100, false);
		}
	} else if(optionGroup == 4) {
		if(optionPosition == 0) {
			menuSwitchOptionGroup(1);
		}
	} else if(optionGroup == 5) {
		if(optionPosition == 0) {
			menuSwitchOptionGroup(1);
		}
	}// so on for more option groups
}
#endregion

#region menu switch option group
menuSwitchOptionGroup = function(newOptionGroup, hardCoded = 0){
	optionGroup = newOptionGroup;
	optionPosition = 0;
	menuAlign = fa_right;
	
	//basic references
	optionAmount = array_length(options[optionGroup]);
	if(hardCoded != 1) {
		//resize menu
		var _maxOptionWidth = 0;
		var _holdWidth = 0;
		for(var optionIterator = 0; optionIterator < optionAmount; optionIterator++) {
			_holdWidth = 1.5 * string_width(options[optionGroup][optionIterator]);
			if(_holdWidth > _maxOptionWidth) {
				_maxOptionWidth = _holdWidth;
			}
		}
		menuWidth = menuBorder * 2 + _maxOptionWidth;
		menuHeight = menuBorder * 2 + optionAmount * optionHeight;
	} else {
		if(newOptionGroup == 4) {
			menuAlign = fa_right;
			menuWidth = 1200;
			menuHeight = 720;
		} else if(newOptionGroup == 2) {
			menuAlign = fa_right;
			menuWidth = 900;
			menuHeight = menuBorder * 2 + optionAmount * optionHeight;
		} else if(newOptionGroup == 3) {
			menuAlign = fa_right;
			menuWidth = 900;
			menuHeight = menuBorder * 2 + optionAmount * optionHeight;
		} else if(newOptionGroup == 5) {
			menuAlign = fa_right;
			menuWidth = 900;
			menuHeight = menuBorder * 2 + optionAmount * optionHeight;
		}
	}

	//x = camera_get_view_x(view_camera[0]) + 240 - menuWidth / 2;
	//y = camera_get_view_y(view_camera[0]) + 135 - menuHeight / 2;
	
	//play sound for switching screen thing
	audio_play_sound(snd_menuBeep, 100, false);
}
#endregion

#region menu switch position
menuSwitchPosition = function(positionChange) {
	if(positionChange != 0) {
		optionPosition = clamp(optionPosition + positionChange, 0, optionAmount - 1);
		audio_play_sound(snd_menuBlip, 100, false);
	}
}
#endregion

menuSwitchOptionGroup(0);

initializeMenu();

// load the sound groups
if(!audio_group_is_loaded(ag_Music))
{
	audio_group_load(ag_Music);
};
if(!audio_group_is_loaded(ag_SFX))
{
	audio_group_load(ag_SFX);
};

//DRAW the stuff from this pause menu pushed off to the side llike in a lot
//of AAA games. Then blur or something the background to make it look cool...