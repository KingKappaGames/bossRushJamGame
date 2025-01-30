if(textBlurFadeX < room_width + 5) {
	draw_sprite_ext(spr_sideBarMenu, 0, textBlurFadeX, 0, 1.25, 1, 0, c_white, 1);
}

if(optionGroup == 4) { // custom draw groups
	draw_sprite(spr_controlDiagram, 0, x, y);
} else if(optionGroup == 2) {
	draw_sprite_ext(spr_optionMeter, gameEffectVolume, x + 320, y - 141, 2.5, 2.5, 0, c_white, 1);
	draw_sprite_ext(spr_optionMeter, gameMusicVolume, x + 320, y - 65, 2.5, 2.5, 0, c_white, 1);
} else if(optionGroup == 3) {
	
} else if(optionGroup == 5) {
	
}

//if(optionGroup == 0) {
//	var _sin = dsin(current_time / 30);
//	draw_sprite_ext(spr_wanderlustTitle, 0, x + menuWidth / 2, y - 20, 1, 1, dsin(current_time / 15) * 3.4, make_color_rgb(255, 230 + _sin * 25, 230 + _sin * 25), 1);
//} // draw the title at top