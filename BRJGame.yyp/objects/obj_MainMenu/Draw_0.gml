if(optionGroup == 4) { // custom draw groups
	draw_sprite(spr_controlDiagram, 0, x, y);
} else if(optionGroup == 2) {
	draw_sprite_ext(spr_optionMeter, gameEffectVolume, x + 114, y - 141, 2.5, 2.5, 0, c_white, 1);
	draw_sprite_ext(spr_optionMeter, gameMusicVolume, x + 114, y - 65, 2.5, 2.5, 0, c_white, 1);
} else if(optionGroup == 3) {
	
} else if(optionGroup == 5) {
	
}

wheelAngle = (wheelAngle + wheelSpinSpeed) % 360;
var _bossWheelCount = array_length(wheelMembers);
var _drawAngle = wheelAngle;
for(var _bossI = 0; _bossI < _bossWheelCount; _bossI++) {
	var _sin = dsin(_drawAngle);
	var _drawCenterness = .67 + _sin / 3;
	if(global.boss_selected == _bossI) {
		draw_sprite_ext(wheelSprites[_bossI], 0, wheelCenterX + dcos(_drawAngle) * wheelWidth, wheelCenterY - _sin * wheelWidth, _drawCenterness * 5, _drawCenterness * 5, 0, make_color_rgb(127 + _drawCenterness * 128, 127 + _drawCenterness * 128, 127 + _drawCenterness * 128), 1);
	} else {
		shader_set(shd_greyScale);
		shader_set_uniform_f((shader_get_uniform(shd_greyScale, "u_GrayscaleAmount")), 1);
		draw_sprite_ext(wheelSprites[_bossI], 0, wheelCenterX + dcos(_drawAngle) * wheelWidth, wheelCenterY - _sin * wheelWidth, _drawCenterness * 5, _drawCenterness * 5, 0, make_color_rgb(_drawCenterness * 255, _drawCenterness * 255, _drawCenterness * 255), 1);
		shader_reset();
	}
	_drawAngle += 360 / _bossWheelCount;
}

//if(optionGroup == 0) {
//	var _sin = dsin(current_time / 30);
//	draw_sprite_ext(spr_wanderlustTitle, 0, x + menuWidth / 2, y - 20, 1, 1, dsin(current_time / 15) * 3.4, make_color_rgb(255, 230 + _sin * 25, 230 + _sin * 25), 1);
//} // draw the title at top