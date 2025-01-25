function script_menuExitLayer(){
	if(object_index != obj_MainMenu) {
		optionPosition = 0;
		menuSelectOption();
	} else {
		if(optionGroup != 0) {
			optionPosition = 0;
			menuSelectOption();
		} else {
			audio_play_sound(snd_menuBeep, 100, false);
		}
	}
}