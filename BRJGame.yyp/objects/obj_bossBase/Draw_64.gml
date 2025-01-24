if(healthBarFade > 0) {
	if(Health <= 0) {
		healthBarFade -= .014;
	} else if(global.gameManager.gameState != "fight") {
		healthBarFade -= .012;
	} else {
		healthBarFade = clamp(healthBarFade + .018, 0, 1);
	}
	
	draw_set_alpha(healthBarFade);
	
	var _leftX = view_wport[0] / 2 + 250;
	var _topY = 40; // top left
	
	var _rightX = view_wport[0] - 50;
	var _bottomY = 80; // bottom right
	
	var _barWidth = _rightX - _leftX;
	
	draw_rectangle_color(_leftX - 2, _topY - 2, _rightX + 2, _bottomY + 2, c_white, c_white, c_white, c_white, false);
	
	draw_rectangle_color(_rightX - (highlightHealth / HealthMax) * _barWidth, _topY, _rightX, _bottomY, #ccdd55, #ccdd55, #ccdd55, #ccdd55, false);
	draw_rectangle_color(_rightX - (Health / HealthMax) * _barWidth, _topY, _rightX, _bottomY, c_red, c_red, c_red, c_red, false);
	
	draw_set_alpha(1);
} else {
	if(Health > 0 && global.gameManager.gameState == "fight") {
		healthBarFade = clamp(healthBarFade + .018, 0, 1);
	}
}