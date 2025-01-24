if(healthBarFade > 0) {
	if(Health <= 0) {
		healthBarFade -= .012;
	} else if(global.gameManager.gameState != "fight") {
		healthBarFade -= .012;
	} else {
		healthBarFade = clamp(healthBarFade + .018, 0, 1);
	}
	
	draw_set_alpha(healthBarFade);
	
	var _leftX = 50;
	var _topY = 40; // top left
	
	var _rightX = view_wport[0] / 2 - 250;
	var _bottomY = 80; // bottom right
	
	var _barWidth = _rightX - _leftX;
	
	draw_rectangle_color(_leftX - 2, _topY - 2, _rightX + 2, _bottomY + 2, c_white, c_white, c_white, c_white, false);
	
	draw_rectangle_color(_leftX, _topY, _leftX + (highlightHealth / HealthMax) * _barWidth, _bottomY, #6E5F84, #6E5F84, #6E5F84, #6E5F84, false);
	draw_rectangle_color(_leftX, _topY, _leftX + (Health / HealthMax) * _barWidth, _bottomY, #161040, #161040, #161040, #161040, false);
	
	draw_set_alpha(1);
} else {
	if(Health > 0 && global.gameManager.gameState == "fight") {
		healthBarFade = clamp(healthBarFade + .018, 0, 1);
	}
}