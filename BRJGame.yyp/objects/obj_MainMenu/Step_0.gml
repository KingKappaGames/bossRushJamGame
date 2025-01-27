menuSwitchPosition(keyboard_check_released(ord("S")) - keyboard_check_released(ord("W")));
menuChangeField(keyboard_check_released(ord("D")) - keyboard_check_released(ord("A")));

if(keyboard_check_released(vk_space) || keyboard_check_released(ord("E")) || (mouse_check_button_released(mb_left) && mouse_x > x + 350)) {
	if(mouse_check_button_released(mb_left)) {
		var _optionHeight = (53 * display_get_gui_height() / room_height); // set the mouse position here
		optionPosition = clamp((mouse_y - (y - (_optionHeight * 2.85))) div _optionHeight, 0, optionAmount - 1);
	}
	menuSelectOption();
} else {
	if(mouse_check_button_released(mb_left)) {
		if(mouse_x < x + 130) {
			var _bossCount = array_length(wheelMembers);
			global.boss_selected = wheelMembers[(((360 - wheelAngle) + 140) div (360 / _bossCount)) % _bossCount];
			wheelSpinSpeed += 1;
		}
	}
}

wheelSpinSpeed = lerp(wheelSpinSpeed, 1.25, .018);

if(window_mouse_get_delta_x() != 0 || window_mouse_get_delta_y() != 0) {
	mouseSelecting = true;
} else {
	mouseSelecting = false;
}


//do selection based on mouse
if(mouse_x > x + 350) {
	if(mouseSelecting) {
		var _optionHeight = (53 * display_get_gui_height() / room_height);
		optionPosition = clamp((mouse_y - (y - (_optionHeight * 2.85))) div _optionHeight, 0, optionAmount - 1);
	}
} else {
	mouseSelecting = false;
}

if(global.musicPlaying != -1) {
	if(audio_group_is_loaded(ag_Music)) { // force music if no music... yeh
		if(!audio_is_playing(snd_mainMenuSongLoop) && !audio_is_playing(snd_mainMenuSongInitial)) { // if no menu music start the first and start the second from then on
			audio_play_sound(global.musicPlaying, 10, true);
			global.musicPlaying = snd_mainMenuSongLoop;
		}
	}
}