if(!global.is_paused) {
	var _links = array_length(global.linksTotalThisFrame);
	if(_links > 0) {
		var _linkList = global.linksTotalThisFrame;
		for(var _i = 0; _i < _links; _i++) {
			draw_line_width_color(_linkList[_i][0].x, _linkList[_i][0].y, _linkList[_i][1].x, _linkList[_i][1].y, 3, c_white, c_ltgray);
		}
	}
}