menuSwitchPosition(keyboard_check_released(ord("S")) - keyboard_check_released(ord("W")));
menuChangeField(keyboard_check_released(ord("D")) - keyboard_check_released(ord("A")));

var _camX = camera_get_view_x(view_camera[0]);
var _camY = camera_get_view_y(view_camera[0]);

if(keyboard_check_released(vk_space) || keyboard_check_released(ord("E")) || (mouse_check_button_released(mb_left) && mouse_x > _camX + 270)) {
	if(mouse_check_button_released(mb_left)) {
		optionPosition = clamp((mouse_y - (_camY + 19)) div 26, 0, optionAmount - 1);
	}
	menuSelectOption();
}

if(window_mouse_get_delta_x() != 0 || window_mouse_get_delta_y() != 0) {
	mouseSelecting = true;
} else {
	mouseSelecting = false;
}

if(mouse_x > _camX + 270) {
	if(mouseSelecting) {
		optionPosition = clamp((mouse_y - (_camY + 19)) div 26, 0, optionAmount - 1);
	}
} else {
	mouseSelecting = false;
}


//if(audio_group_is_loaded(ag_Music)) { // force music if no music... yeh
//	if(!audio_is_playing(snd_mainMenuSong)) {
//		//audio_play_sound(snd_mainMenuSong, 10, true);
//	}
//}