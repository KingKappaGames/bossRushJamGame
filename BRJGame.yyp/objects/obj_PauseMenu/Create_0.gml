draw_set_font(global.fontPixel);

depth = -1000;

menuWidth = 300;
menuHeight = 240;

options[0][0] = "resume";
options[0][1] = "options";
options[0][2] = "main menu";
				       
options[1][0] = "return";
options[1][1] = "sounds";
options[1][2] = "visuals";
options[1][3] = "settings";
options[1][4] = "controls";
				         
options[2][0] = "return";
options[2][1] = "effects";
options[2][2] = "music";
				        
options[3][0] = "return";
options[3][1] = "screen area";
options[3][2] = "window";
				         
options[4][0] = "return";
options[4][1] = "difficulty";
options[4][2] = "view shake";
			    
options[5][0] = "return";

optionPosition = 0;
optionGroup = 0;
optionAmount = 4;

optionHeight = 105;
menuBorder = 60;
menuAlign = fa_right;

mouseSelecting = false;

pauseSurfaceBuffer = buffer_create(1920 * 1080 * 4, buffer_fixed, 1);
pauseSurface = -1;

//game settings in menu
gameDifficultyDisplayOptions = ["simple", "normal", "spinner"];
gameDifficultySelected = global.gameDifficultySelected;

gameScreenShakeDisplayOptions = ["none", "minimal", "default", "shakey", "awful"];
gameScreenShakeSelected = global.gameScreenShakeSelected;

gameWindowResolutionSelected = global.gameWindowResolutionSelected;
gameWindowResolutionOptions = ["small", "medium", "large", "xl"];

gameFullscreenSelected = global.gameFullscreenSelected;
gameFullscreenOptions = [false, true];
gameFullscreenDisplayOptions = ["windowed", "fullscreen"];

gameEffectVolume = global.gameEffectVolume;
gameMusicVolume = global.gameMusicVolume;

#region initialize menu
initializeMenu = function(){
	var _rezSize = [[480, 270], [1280, 720], [1920, 1080], [2560, 1440]];
	window_set_size(_rezSize[gameWindowResolutionSelected][0], _rezSize[gameWindowResolutionSelected][1]);
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
				var _rezSize = [[480, 270], [1280, 720], [1920, 1080], [2560, 1440]];
				window_set_size(_rezSize[gameWindowResolutionSelected][0], _rezSize[gameWindowResolutionSelected][1]);
				window_center();
			} else if(optionPosition == 2) {
				//change window configuration
				gameFullscreenSelected = clamp(gameFullscreenSelected + fieldChange, 0, 1);
				window_set_fullscreen(gameFullscreenOptions[gameFullscreenSelected]);
			}
		} else if(optionGroup == 4) {
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
			audio_play_sound(snd_menuStart, 100, false);
			script_setPauseState(false);
			instance_destroy();
		} else if(optionPosition == 1) {
			menuSwitchOptionGroup(1);
		} else if(optionPosition == 2) {
			audio_stop_all();

			room_goto(rm_Main_Menu);
		}
	} else if(optionGroup == 1) {
		if(optionPosition == 0) {
			menuSwitchOptionGroup(0);
		} else if(optionPosition == 1) {
			menuSwitchOptionGroup(2, 1);
		} else if(optionPosition == 2) {
			menuSwitchOptionGroup(3, 1);
		} else if(optionPosition == 3) {
			menuSwitchOptionGroup(4, 1);
		} else if(optionPosition == 4) {
			menuSwitchOptionGroup(5, 1);
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
		} else if(newOptionGroup == 4) {
			menuAlign = fa_right;
			menuWidth = 900;
			menuHeight = menuBorder * 2 + optionAmount * optionHeight;
		}
	}

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

script_setPauseState(true, true);