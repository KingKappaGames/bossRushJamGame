var _screenRight = display_get_gui_width();

draw_set_halign(menuAlign);

for(var _iterator = 0; _iterator < optionAmount; _iterator++) {
	var _textColor = c_white;
	if(_iterator == optionPosition) {
		_textColor = c_yellow;
	}
	draw_text_transformed_color(_screenRight - 70, menuBorder + _iterator * optionHeight, options[optionGroup][_iterator], 2, 2.5, 0, _textColor, _textColor, _textColor, _textColor, 1);
}

if(optionGroup == 3) {
	draw_set_halign(fa_right);
	var _fullscreenVar = "";
	if(window_get_fullscreen()) {
		_fullscreenVar = "*";
	}
	draw_text_transformed(_screenRight - 624, 165, string(gameWindowResolutionOptions[gameWindowResolutionSelected][0]) + ", " + string(gameWindowResolutionOptions[gameWindowResolutionSelected][1]) + _fullscreenVar, 2, 2.5, 0);
	draw_text_transformed(_screenRight - 624, 270, string(gameFullscreenDisplayOptions[gameFullscreenSelected]), 2, 2.5, 0);
} else if(optionGroup == 5) {
	draw_set_halign(fa_right)
	draw_text_transformed(_screenRight - 624, 165, string(gameDifficultyDisplayOptions[gameDifficultySelected]), 2, 2.5, 0);
	draw_text_transformed(_screenRight - 624, 270, string(gameScreenShakeDisplayOptions[gameScreenShakeSelected]), 2, 2.5, 0);
}

draw_set_halign(fa_left); // default