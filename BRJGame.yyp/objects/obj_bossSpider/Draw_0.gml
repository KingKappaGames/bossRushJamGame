event_inherited();

var _legPos = 0;
var _legPosGoal = 0;
var _legOrigin = 0;
var _legBeginX = 0;
var _legBeginY = 0;
for(var _legI = 0; _legI < 8; _legI++) {
	_legPos = legPositions[_legI];
	_legPosGoal = legPositionGoals[_legI];
	_legOrigin = legOrigins[_legI];

	var _distFoot = point_distance(x, y, _legPos[0], _legPos[1]);
	var _footJointDist = sqrt(abs(sqr(legSegLen) - sqr(_distFoot / 2))); // abs does nothing here in theory but if you ever get a negative number (which again you shouldn't but hey) it'll make it positive. Presumably this negative number would be tiny and the difference would be unnoticable. Ergo abs is the easiest way to prevent the negative besides clamp with is ugly

	var _legMidX = (_legOrigin[0] + _legPos[0]) / 2;
	var _legMidY = (_legOrigin[1] + _legPos[1]) / 2 - _footJointDist;
	
	draw_line_width(_legOrigin[0], _legOrigin[1], _legMidX, _legMidY, 5);
	draw_line_width(_legMidX, _legMidY, _legPos[0], _legPos[1], 3);
}





//slime stuff

//surface_set_target(script_getDebrisSurface());
//gpu_set_blendmode_ext(bm_src_color, bm_dest_alpha); // why is gpu max just making everything black I don't udnerstand, unless it's adding to each channel ind giving a low max in each channel aka dark grey??
//draw_set_alpha(.3);
//draw_ellipse(x - 20 + irandom_range(-10, 10), y - 12 + irandom_range(-8, 8), x + 20 + irandom_range(-10, 10), y + 12 + irandom_range(-8, 8), false);
//draw_set_alpha(1);
//gpu_set_blendmode(bm_normal);
//surface_reset_target();