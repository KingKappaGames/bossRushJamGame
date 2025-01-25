if(optionGroup == 0) {
	script_setPauseState(false);
	instance_destroy();
} else {
	script_menuExitLayer();
}

keyboard_clear(vk_escape);