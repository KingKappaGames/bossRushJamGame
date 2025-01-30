menuSwitchPosition(keyboard_check_released(ord("S")) - keyboard_check_released(ord("W")));
menuChangeField(keyboard_check_released(ord("D")) - keyboard_check_released(ord("A")));

if(keyboard_check_released(vk_space) || keyboard_check_released(ord("E")) || (mouse_check_button_released(mb_left) && mouse_x > x + 350 && mouse_y < y + 150)) {
	if(mouse_check_button_released(mb_left)) {
		var _optionHeight = (53 * display_get_gui_height() / room_height); // set the mouse position here
		optionPosition = clamp((mouse_y - (y - (_optionHeight * 2.85))) div _optionHeight, 0, optionAmount - 1);
	}
	menuSelectOption();
}

if(window_mouse_get_delta_x() != 0 || window_mouse_get_delta_y() != 0) {
	mouseSelecting = true;
} else {
	mouseSelecting = false;
}


//do selection based on mouse
if(mouse_x > x + 350 && mouse_y < y + 150) {
	textBlurFadeX = lerp(textBlurFadeX, room_width * .34, .05);
	if(mouseSelecting) {
		var _optionHeight = (53 * display_get_gui_height() / room_height);
		optionPosition = clamp((mouse_y - (y - (_optionHeight * 2.85))) div _optionHeight, 0, optionAmount - 1);
	}
} else {
	if(optionGroup == 0) {
		textBlurFadeX = lerp(textBlurFadeX, room_width + 20, .07);
	}
	mouseSelecting = false;
	
	if(mouse_check_button_released(mb_left)) {
		if(point_distance(mouse_x, mouse_y, x - 200, y + 300) < 180) { // mantis
			if(global.boss_selected == 1) {
				global.boss_selected = -1;
			} else {
				global.boss_selected = 1;
			}
		} else if(point_distance(mouse_x, mouse_y, x + 500, y + 300) < 210) { // pollie
			if(global.boss_selected == 2) {
				global.boss_selected = -1;
			} else {
				global.boss_selected = 2;
			}
		} else if(point_distance(mouse_x, mouse_y, x + 75, y + 10) < 240) { // spider
			if(global.boss_selected == 0) {
				global.boss_selected = -1;
			} else {
				global.boss_selected = 0;
			}
		}
	}
}

if(global.musicPlaying != -1) {
	if(audio_group_is_loaded(ag_Music)) { // force music if no music... yeh
		if(!audio_is_playing(snd_mainMenuSongLoop) && !audio_is_playing(snd_mainMenuSongInitial)) { // if no menu music start the first and start the second from then on
			global.musicActualPlaying = audio_play_sound(global.musicPlaying, 10, true);
			global.musicPlaying = snd_mainMenuSongLoop;
		}
	}
}